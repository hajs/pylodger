import sys
import argparse
import urllib
import os
import re
from autobuilder import Recipe
from verlib import suggest_normalized_version, NormalizedVersion


def extract_links(html):
    pat = '<a href="(.*?)" rel="internal">(.*?)</a>'
    return re.findall(pat, html)

def remove_ext(filename):
    for ext in (".zip", ".bz2", ".gz", ".tar", ".tgz", ".tbz2", ".egg"):
        filename = filename.rstrip(ext)
    return filename

def extract_version(filename):
    filename = remove_ext(filename)
    parts = filename.split("-")
    version = "0.0"
    for i, p in enumerate(parts):
        if re.match("[A-Za-z_]", p):
            continue
        version = "-".join(parts[i:])
        break
    return NormalizedVersion(suggest_normalized_version(version) or "0.0")


def check_pypi(r):
    name = r.name
    version = r.version
    try:
        url = r.meta["source"]["url"]
    except KeyError:
        url = r.meta["source"]["giturl"]
    url_parts = url.split("/")
    filename = url_parts[-1]
    pkg_name = url_parts[-2]
    index_url = "https://pypi.python.org/simple/%s/" % pkg_name
    index_html = urllib.urlopen(index_url).read()
    print "%s %s (%s)" % (name, version, filename) 
    version = extract_version(filename)
    found = {}
    for rel_url, pkg_filename in extract_links(index_html):
        pkg_url, hash_type, md5hash = urllib.basejoin(url, rel_url).partition("#md5=")
        assert hash_type == "#md5="
        pkg_version = extract_version(pkg_filename)
        if pkg_version > version:
            found.setdefault(pkg_version, []).append(pkg_filename)
    if found:
        print "-> found newer versions:", " ".join(map(str, sorted(found.keys())))
    
    
def check(path):
    r = Recipe.parse(path)
    try:
        url = r.meta["source"]["url"]
    except KeyError:
        return
    if url.startswith("https://pypi.python.org"):
        return check_pypi(r)
    else:
        print "not a pypi package", url
    
def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("recipe", nargs="+")
    args = parser.parse_args()
    for recipe_path in args.recipe:
        check(recipe_path)


if __name__ == "__main__":
    sys.exit(main() or 0)
