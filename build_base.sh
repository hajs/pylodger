#!/bin/bash
set -e  -x 

DIST=$1
TARGET=$2

function usage() {
  echo "Usage: $0 FROM_DISTRIBUTION TARGET"
  exit 1
}

if [ "$DIST" = "" ]
then
  usage
else
  for tool in python conda
  do
    if [ -f "$DIST/bin/$tool" ]
    then
       echo "Found $DIST/bin/$tool"
    else
       echo "Error: Could not find $DIST/bin/$tool"
       exit 2
    fi
  done
fi
if [ "$TARGET" = "" ]
then
  usage
else
  if [ -d $TARGET ]
  then
    echo "Warning: Target $TARGET already exists"
  fi
fi

# XXX: assume that pkgdir is empty
PKGDIR=$DIST/conda-bld/linux-64/
PYTHON=$DIST/bin/python
CONDA="$PYTHON $DIST/bin/conda"

mkdir -p $TARGET/{pkgs,envs,conda-meta,conda-bld}
for package in system zlib bzip2 openssl ncurses readline sqlite python pycosat yaml pyyaml conda setuptools distribute
do
  test -f $PKGDIR/$package*.tar.bz2 || $CONDA build recipes/base/$package
  pkgfile=$PKGDIR/$package*.tar.bz2
  tar -xj -C $TARGET -f $pkgfile
done


# Fix wrong paths
PLACEHOLDER="/opt/anaconda1anaconda2anaconda3"
for fixfile in $(grep -rl "$PLACEHOLDER" $TARGET/bin)
do
  $TARGET/bin/python relocate.py $PLACEHOLDER $TARGET $fixfile
done


# copy created packages
cp $PKGDIR/*.tar.bz2 $TARGET/pkgs/


# reinstall via conda 
echo "
channels:
   - file://$(readlink -f $PKGDIR/..)
" > ~/.condarc

for pkgfile in $TARGET/pkgs/*.tar.bz2
do
  $TARGET/bin/conda install -c system $pkgfile
done
