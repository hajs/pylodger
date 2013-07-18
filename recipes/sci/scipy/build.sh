#!/bin/sh
export LAPACK=$PREFIX/lib/liblapack.so
export BLAS=$PREFIX/lib/libfblas.so
export ATLAS=$PREFIX/lib/libsatlas.so
test -f $BLAS
test -f $LAPACK
test -f $ATLAS

$PYTHON setup.py install

