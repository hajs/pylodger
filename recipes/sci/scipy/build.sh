#!/bin/sh
export LAPACK=$PREFIX/lib/liblapack.so
export BLAS=$PREFIX/lib/libf77blas.so
export ATLAS=$PREFIX/lib/libatlas.so
test -f $LAPACK
test -f $BLAS
test -f $ATLAS

$PYTHON setup.py install

