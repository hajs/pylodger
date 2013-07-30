#!/bin/sh

cd geos-3.3.3
export GEOS_DIR=$PREFIX
./configure --prefix=$GEOS_DIR
make; make install
cd ..

$PYTHON setup.py install

