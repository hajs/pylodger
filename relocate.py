#!/usr/bin/env python
# -*- coding: utf-8 -*-
"Relocate prefix by in-place search&replace"
import sys
import argparse


def relocate(old, new, files, dry_run=False, verbose=True):
    for filename in files:
        data = open(filename).read()
        if data.startswith("ELF"):
            if verbose:
                print sys.stderr, "Not relocating", filename, "is an elf binary"
            continue
        else:
            if not data.startswith("#!"):
                if verbose:
                    print >>sys.stderr, "Not relocating", filename, "does not start with #!"
                    continue
        print "Relocating", filename
        if dry_run:
            continue
        data = data.replace(old, new)
        open(filename, 'w').write(data)


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--verbose", "-v", action="store_true", default=False, help="dry run")
    parser.add_argument("--dry", "-d", action="store_true", default=False, help="dry run")
    parser.add_argument("old")
    parser.add_argument("new")
    parser.add_argument("files", nargs="+")
    args = parser.parse_args()
    relocate(args.old, args.new, args.files, dry_run=args.dry, verbose=args.verbose)



if __name__ == "__main__":
    sys.exit(main() or 0)
