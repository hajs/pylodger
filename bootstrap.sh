#!/bin/bash
set -e -x

DIST=/opt/anaconda
TARGET=/tmp/freeconda
PKGDIR=$DIST/conda-bld/linux-64/
PYTHON=$DIST/bin/python
CONDA="$PYTHON $DIST/bin/conda"

for package in system zlib bzip2 openssl readline sqlite python pycosat conda setuptools
do
  test -f $PKGDIR/$package*.tar.bz2 || $CONDA build $package
done

mkdir -p $TARGET/{pkgs,envs,conda-meta,conda-bld}
for pkgfile in $PKGDIR/*.tar.bz2
do
  tar -xjv -C /tmp/freeconda -f $pkgfile
done

cp $PKGDIR/*.tar.bz2 $TARGET/pkgs/

PLACEHOLDER="/opt/anaconda1anaconda2anaconda3"
echo "import sys
filename, old, new = sys.argv[1], sys.argv[2], sys.argv[3]
data = open(filename).read()
data = data.replace(old, new)
open(filename, 'w').write(data)
" > fix.py
for fixfile in $(grep -rl "$PLACEHOLDER" $TARGET/bin)
do
  $TARGET/bin/python fix.py $fixfile $PLACEHOLDER $TARGET
done
rm fix.py

for pkgfile in $TARGET/pkgs/*.tar.bz2
do
  $TARGET/bin/conda install $pkgfile
done
