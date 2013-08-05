#!/usr/bin/env python
# -*- coding: utf-8 -*-
import sys
import os
import platform
import datetime
import json
import argparse
from collections import namedtuple
import yaml

DRY_RUN = False


def detect_system():
    env_vars = "linux linxu32 linux64 armv6 osx unix win win32 win64 py2k py26 py27 py3k py33".split()
    ctx = dict([(key, False) for key in env_vars])
    machine = platform.machine()

    if sys.platform.startswith("linux"):
        ctx.update(linux=True, unix=True)
        if machine == "x86_64":
            ctx.update(linux64=True)
        elif machine == "i386":
            ctx.update(linux32=True)
        else:
            #ctx.update(armv6=True)
            raise RuntimeError("Platform %r currently not supported" % sys.platform)
    elif sys.platform.startswith("win"):
        if machine == "x86_64":
            ctx.update(win64=True)
        elif machine == "i386":
            ctx.update(win32=True)
        else:
            raise RuntimeError("Platform %r currently not supported" % sys.platform)
    if sys.version.startswith("2.6"):
        ctx.update(py26=True, py2k=True)
    elif sys.version.startswith("2.7"):
        ctx.update(py27=True, py2k=True)
    elif sys.version.startswith("3.3"):
        ctx.update(py33=True, py3k=True)
    else:
        assert sys.version.startswith("3.")
        ctx.update(py3k=True)
    return ctx

system_context = detect_system()
#print "Host system:", 
#for key, value in sorted(system_context.items()):
#    if value: print key,
#print


def parse_requirement(dep):
    if "[" in dep:
        dep, _sep, cond = dep.partition("[")
        cond = cond.strip().rstrip("]")
        match = eval(cond, system_context)
        if not match:
            print "not matched", cond
            return None
    return dep.strip()


class Recipe(object):

    @classmethod
    def parse(cls, path):
        recipe_name = os.path.basename(path)
        files = []
        for name in os.listdir(path):
            if name.endswith(("~", ".pyc", ".pyo", "#")) or \
               name.startswith((".", "_")):
                continue # ignore
            filename = os.path.join(path, name)
            mtime = os.path.getmtime(filename)
            mtime = datetime.datetime.utcfromtimestamp(mtime)
            entry = (filename, mtime)
            files.append(entry)
        files.sort(key=lambda  entry: entry[1])
        last_changed = files[-1][1]
        meta = yaml.load(open(os.path.join(path, "meta.yaml")))
        info = dict(meta,
                    path=path,
                    recipe_name=recipe_name,
                    last_changed=last_changed,
                    files=files)
        return cls(info)
        
    def __init__(self, meta):
        self.path = meta["path"]
        self.recipe_name = meta["recipe_name"]
        self.last_changed = meta["last_changed"]
        self.build_deps = []
        for dep in meta.get("requirements", {}).get("build", []):
            dep = parse_requirement(dep)
            if not dep:
                continue
            self.build_deps.append(dep)
        self.run_deps = meta.get("requirements", {}).get("run", [])
        self.name = meta.get("package", {}).get("name")
        self.version = str(meta["package"]["version"])
        self.meta = meta
        self.check()

    def check(self):
        warnings = []
        if self.recipe_name != self.name:
            warnings.append("Folder name %r does not match name %r" % (
                self.recipe_name, self.name))

    def __repr__(self):
        return "<%s %r>" % (self.__class__.__name__, self.meta)


class Dependencies(object):

    def __init__(self):
        self._dmap = {}

    def register(self, item, *requires):
        self._dmap.setdefault(item, []).extend(list(requires))

    def resolve(self, item):
        deps = [item]
        for item in deps:
            for item_dep in self._dmap.get(item, []):
                if item_dep not in deps:
                    deps.append(item_dep)
        return list(reversed(deps[1:]))
        

class RecipeManager(object):

    def __init__(self, root):
        self.root = root
        self.recipes =  self.discover(self.root)
        self.recipes.sort(key=lambda r:r.last_changed)
        self.dependencies = Dependencies()
        for r in self.recipes:
            self.dependencies.register(r.name, *r.build_deps)
                        
    def new_recipes(self, newer_than):
        return [recipe for recipe in self.recipes \
                if recipe.last_changed  >= newer_than ]
    
    def discover(self, root):
        recipes = []
        for (path, sub_folders, names)  in os.walk(root):
             if "meta.yaml" in names:
                r = Recipe.parse(path)
                recipes.append(r)
        return recipes
    
    def find(self, name):
        l = []
        for r in self.recipes:
            if r.name == name:
                l.append(r)
        return l


class Package(namedtuple("Package", "filename name version depends")):
    pass

class RepositoryCache(object):

    def __init__(self, path):
        with open(os.path.join(path, "repodata.json")) as rf:
            self.repodata = json.load(rf)
        self.packages = []
        for (pkg_name, pkg_data) in self.repodata["packages"].items():
            pkg = Package(filename=pkg_name,
                          name=pkg_data["name"],
                          version=pkg_data["version"],
                          depends=pkg_data["depends"])
            self.packages.append(pkg)

    def find(self, name):
        l = []
        for pkg in self.packages:
            if pkg.name == name:
                l.append(pkg)
        return l

        
class CondaError(Exception):
    pass

class Conda(object):

    def __init__(self, prefix=None, verbose=True):
        if prefix is None:
            prefix = sys.prefix
        self.verbose = verbose
        self.executable = os.path.join(prefix, "bin", "conda")

    def _call(self, *args):
        cmd = "%s %s 2>&1" % (self.executable, " ".join(args))
        if self.verbose:
            print >>sys.stderr, "[CALLING]", cmd
        pipe =  os.popen(cmd)
        if 0: #self.verbose:
            output = ""
            line = pipe.readline()
            while line:
                sys.stderr.write(line)
                output = output + line
                line = pipe.readline()
        else:
            output = pipe.read()
        exit_code = pipe.close()
        if exit_code != 0:
            raise CondaError(output)
        return output

    def install(self, *packages):
        output = self._call("install", "-f", *packages)

    def build(self, *recipes):
        output = self._call("build", "--no-binstar-upload", *recipes)


class Error(Exception):
    pass


class AutoBuilder(object):

    def __init__(self, dist_prefix, recipe_root):
        self.dist_prefix = dist_prefix
        self.recipe_root = recipe_root
        self.rep_path = os.path.join(dist_prefix, "conda-bld", "linux-64")
        self.rm = RecipeManager(self.recipe_root)
        self.rc = RepositoryCache(self.rep_path)
        self.conda = Conda(self.dist_prefix)

    def build(self, pkg):
        new_packages = []
        deps = self.rm.dependencies.resolve(pkg)
        print pkg, "depends on", " ".join(deps)  or "(nothing)"
        for dep_pkg in deps:
            if self.rc.find(dep_pkg):
                print "already built:", dep_pkg
            else:
                recipes = self.rm.find(dep_pkg)
                if not recipes:
                    raise Error("Unknown how to build %r" % dep_pkg)
                recipes.sort(key=lambda r:r.version)
                dep_recipe = recipes[-1]
                print "building", dep_pkg, "from", dep_recipe.path
                self.conda.build(dep_recipe.path)
                new_packages.append(dep_pkg)
        print "building", pkg
        new_packages.append(pkg)
        self.conda.build(pkg)
                            
        
        
def do_build(args):
    ab = AutoBuilder(args.prefix, args.root)
    built = []
    for pkg in args.package:
        if pkg in built:
            continue # XXX: print something?
        ab.build(pkg)


def do_list(args):
    rm = RecipeManager(args.root)
    for recipe in rm.recipes:
        print recipe.name.ljust(30), recipe.version.ljust(10),
        print recipe.last_changed.strftime("%Y-%m-%d %H:%M")

        
def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("-dry", "-d", action="store_true", default=False, help="dry run")
    parser.add_argument("--root", "-r", default=os.getcwd(), 
                        help="default recipe root folder %(default)r")
    parser.add_argument("--prefix", "-p", default=sys.prefix, 
                        help="default is distribution prefix is %r" % sys.prefix)
    parser.add_argument("--verbose", action="store_true", default=False)
    sub_parsers = parser.add_subparsers()
    build_parser = sub_parsers.add_parser("build")
    build_parser.add_argument("package", nargs="+")
    build_parser.set_defaults(func=do_build)
    list_parser = sub_parsers.add_parser("list")
    list_parser.set_defaults(func=do_list)
    
    args = parser.parse_args()
    DRY_RUN = args.dry        
    args.func(args)

    
if __name__ == "__main__":
    sys.exit(main() or 0)
