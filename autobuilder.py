#!/usr/bin/env python
# -*- coding: utf-8 -*-
import sys
import os
import re
import time
import platform
import datetime
import json
import argparse
import fnmatch
from collections import namedtuple
import yaml
import shelve



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


class Package(namedtuple("Package", "filename name version depends files")):
    pass

class RepositoryCache(object):

    def __init__(self, path):
        if os.path.isdir(path):
            path  = os.path.join(path, "repodata.json")
        with open(path) as rf:
            self.repodata = json.load(rf)
        self.packages = []
        for (pkg_name, pkg_data) in self.repodata["packages"].items():
            pkg = Package(filename=pkg_name,
                          name=pkg_data["name"],
                          version=pkg_data["version"],
                          depends=pkg_data["depends"], 
                          files=None)
            self.packages.append(pkg)

    def find(self, name):
        l = []
        for pkg in self.packages:
            if pkg.name == name:
                l.append(pkg)
        return l

        
class CondaError(Exception):
    pass



def call(*args):
    cmd = "LANG=en %s 2>&1" % " ".join(args)
    pipe =  os.popen(cmd)
    output = pipe.read()
    exit_code = pipe.close()
    return exit_code, output


class Conda(object):

    def __init__(self, prefix=None, verbose=True):
        if prefix is None:
            prefix = sys.prefix
        self.verbose = verbose
        self.executable = os.path.join(prefix, "bin", "conda")

    def _call(self, *args):
        exit_code, output = call(self.executable, *args)
        if exit_code != 0:
            raise CondaError(output)
        return output
        
    def install(self, *packages):
        output = self._call("install", "-f", *packages)

    def build(self, *recipes):
        output = self._call("build", "--no-binstar-upload", *recipes)

    def installed_list(self):
        output = self._call("list")
        return output.splitlines()

class Error(Exception):
    pass


def hg_version(url, branch=None):
	if branch:
		url = "%s#%s" % (url, branch)
	return call("hg", "identify", "-r", "tip", url)[1].strip()

def git_version(url, branch="master"):
    result = call("git", "ls-remote", "--heads", url, branch)[1]
    return result.split()[0]

def svn_version(url):
	output = call("svn", "info", "-r", "HEAD", url)[1]
	rev_re = re.compile("Revision: (?P<revision>\d+)")
	found = re.search(rev_re, output)
	return found.group("revision")

def poll(source):
    if "svn_url" in source:
        return svn_version(source["svn_url"])
    elif "hg_url" in source:
        return hg_version(source["hg_url"])
    else:
        assert "git_url" in source, "unknown vcs-source: %r" % source
        return git_version(source["git_url"])


# XXX: support compact yaml syntax?
_build_re = re.compile("build:\s+number:\s*(?P<number>\d+)", re.DOTALL)

class VersionBumper(object):
    # XXX: fully support semantic versioning specification (semver.org)
    
    def __init__(self, filename):
        self.filename = filename
        with open(self.filename) as mf:
            self.data = mf.read()
        self.meta = yaml.load(self.data)
        self.version = str(self.meta["package"]["version"])
        self.build = self.meta.get("build", {}).get("number", 0)
        self.build_matched = re.search(_build_re, self.data)
        if self.build_matched:
            found_build = int(self.build_matched.group("number"))
            assert found_build == self.build

    def _save(self, data):
        with open(self.filename, "w") as mf:
            mf.write(data)
            
    def replace(self, new_version):
        data = self.data.replace(self.version, new_version)
        self._save(data)
        return new_version

    def increase(self, count=1, pos=-1):
        parts = self.version.split(".")
        version_part = int(parts[pos]) + count
        parts[pos] = str(version_part)
        new_version = ".".join(parts)
        self.replace(new_version)
        return new_version

    def new_build(self, count=1):
        if self.build > 0 and not self.build_matched:
            raise Error("Could not parse build entry")
        build = str(self.build + count)
        if self.build_matched:
            print dir(self.build_matched)
            start, end = self.build_matched.span("number")
            data = self.data[:start] + build + self.data[end:]
        else:
            data = self.data + "\nbuild:\n  number: %s\n" % build 
        self._save(data)
        return build


class PackageDatabase(object):
    
    def __init__(self, prefix):
        self.packages = self.discover(prefix)
        
    def find(self, name):
        if callable(name):
            match = name
        else:
            match = lambda entry: entry.name == name
        for pkg in self.packages:
            if match(pkg):
                yield pkg

    def discover(self, prefix):
        packages = []
        path = os.path.join(prefix, "conda-meta")
        for name in os.listdir(path):
            filename = os.path.join(path, name)
            if name.endswith(".json") and not os.path.isdir(filename):
                pkg = self.parse_pkginfo(filename)
                packages.append(pkg)
        return packages
                
    def parse_pkginfo(self, filename):
        with open(filename) as f:
            pkg_data = json.load(f)
            pkg = Package(filename=filename,
                          name=pkg_data["name"],
                          version=(pkg_data["version"], pkg_data["build_number"]),
                          depends=pkg_data.get("depends", []),
                          files=pkg_data["files"]
                          )
        return pkg


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
    "build recipe(s)"
    ab = AutoBuilder(args.prefix, args.root)
    built = []
    for pkg in args.package:
        if pkg in built:
            continue # XXX: print something?
        ab.build(pkg)


def do_recipes(args):
    "show available recipes"
    rm = RecipeManager(args.root)
    for recipe in rm.recipes:
        print recipe.name.ljust(30), recipe.version.ljust(10),
        print recipe.last_changed.strftime("%Y-%m-%d %H:%M")


def do_repository(args):
    "show packages in repository"
    if os.path.isdir(args.path):
        filename = os.path.join(args.path, "repodata.json")
    else:
        filename = args.path
    if not os.path.exists(filename):
        raise Error("Could not find %r" % filename)
    rc = RepositoryCache(filename)
    for pkg in rc.packages:
        print pkg.name.ljust(20), pkg.version.rjust(10), "   (%s)" % pkg.filename


def _print_pkg(pkg):
    version, build = pkg.version
    print pkg.name.ljust(20), version.rjust(10), "-", build
        
def do_contents(args):
    "show files of package"
    pkg_db = PackageDatabase(args.prefix)
    for pkg in pkg_db.find(args.name):
        _print_pkg(pkg)
        for filename in pkg.files:
            print "  ", filename

def do_pgrep(args):
    "search for packages with given contents"
    pkg_db = PackageDatabase(args.prefix)
    for pkg in pkg_db.packages:
        for filename in pkg.files:
            if fnmatch.fnmatch(filename, args.pattern):
                print pkg.name.ljust(20), filename

            
def do_installed(args):
    "show installed packages"
    pkg_db = PackageDatabase(args.prefix)
    for pkg in pkg_db.packages:
        _print_pkg(pkg)


def do_updates(args):
    "show packages which could be updated"
    rc = RepositoryCache(filename)
    pkg_db = PackageDatabase(args.prefix)
    for installed in pkg_db.packages:
        for available in rc.packages:
            if installed.name != available.name:
                continue
            if installed.version[0] < available.version:
                print installed, available
            break

        
def do_bump(args):
    "increate version or build number"
    if os.path.isdir(args.recipe):
        filename = os.path.join(args.recipe, "meta.yaml")
    else:
        filename = args.recipe
    if not os.path.exists(filename):
        parser.error("Cound not find %r" % filename)
    vb = VersionBumper(filename)
    if args.version == "+":
        version = vb.version
        revision = svn_version(vb.meta["svn_url"])
        version = ".".join(version.split(".")[:-1] + [revision])
        print vb.replace(version)
    elif args.version.startswith("+"):
        count = int(args.version[1:] or 1)
        print vb.increase(count)
    elif args.version == "=":
        print vb.new_build()
    else:
        print vb.replace(args.version)
    

def do_poll(args):
    rlist = []
    rev_db = shelve.open("revisions.db", "c")
    for path in args.recipe:
        try:
            r = Recipe.parse(path)
        except Exception, exc:
            print >>sys.stderr, "Skipping %s: %s" % (path, str(exc))
            continue
        src = r.meta.get("source", {})
        if "hg_url" in src or "svn_url" in src or "git_url" in src and "svn_revision" not in src:
            print "Polling", path                
            rlist.append(r)
        else:
            print >>sys.stderr, "Cannot poll", path
    if not rlist:
        print "Not recipes found. Exiting."
        return 1
    if args.action == "bump":
        args.action = "%s %s bump {} +1" % (sys.executable, sys.argv[0])
        print "bump action: %s" %args.action
    while True:
        for r in rlist:
            try:
                old_revision = rev_db[r.path]
            except:
                old_revision = None
            revision = poll(r.meta["source"])
            if revision != old_revision:
                print "changed:", revision, r.path
                rev_db[r.path] = revision
                rev_db.sync()
                if args.action:
                    cmd = args.action.replace("{}", r.path)
                    print cmd
        time.sleep(args.interval)


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--root", "-r", default=os.getcwd(), 
                        help="default recipe root folder %(default)r")
    parser.add_argument("--prefix", "-p", default=sys.prefix, 
                        help="default is distribution prefix is %r" % sys.prefix)
    parser.add_argument("--verbose", action="store_true", default=False)
    sub_parsers = parser.add_subparsers()
    build_parser = sub_parsers.add_parser("build", help=do_build.__doc__)
    build_parser.add_argument("package", nargs="+")
    build_parser.set_defaults(func=do_build)
    recipes_parser = sub_parsers.add_parser("recipes", help=do_recipes.__doc__)
    recipes_parser.set_defaults(func=do_recipes)
    installed_parser = sub_parsers.add_parser("installed", help=do_installed.__doc__)
    installed_parser.set_defaults(func=do_installed)
    contents_parser = sub_parsers.add_parser("contents", help=do_contents.__doc__)
    contents_parser.add_argument("name", help="name of package")
    contents_parser.set_defaults(func=do_contents)
    pgrep_parser = sub_parsers.add_parser("pgrep", help=do_pgrep.__doc__)
    pgrep_parser.add_argument("pattern", help="file pattern")
    pgrep_parser.set_defaults(func=do_pgrep)
    repository_parser = sub_parsers.add_parser("repository", help=do_repository.__doc__)
    repository_parser.add_argument("path")
    repository_parser.set_defaults(func=do_repository)
    bump_parser = sub_parsers.add_parser("bump", help=do_bump.__doc__)
    bump_parser.add_argument("recipe", help="meta.yaml file for recipe")
    bump_parser.add_argument("version")    
    bump_parser.set_defaults(func=do_bump)
    poll_parser = sub_parsers.add_parser("poll", help=do_poll.__doc__)
    poll_parser.add_argument("--interval", "-i", type=int, default=900,
                             help="poll interval in seconds. default is %(default)s")
    poll_parser.add_argument("--action", "-a", default=None)
    poll_parser.add_argument("recipe", nargs="+", help="path to recipe(s)")
    poll_parser.set_defaults(func=do_poll)
    
    args = parser.parse_args()
    args.func(args)

    
if __name__ == "__main__":
    sys.exit(main() or 0)
