#!/bin/sh
DIST=/opt/anaconda
TARGET=/tmp/freeconda
PKGDIR=$DIST/conda-bld/
cd $PKGDIR
echo "
channels:
      #- defaults
      - http://localhost:8000
" > ~/.condarc

python -m SimpleHTTPServer