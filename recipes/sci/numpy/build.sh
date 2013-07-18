#!/bin/sh
export LAPACK=$PREFIX/lib/liblapack.so
export BLAS=$PREFIX/lib/libf77blas.so
export ATLAS=$PREFIX/lib/libatlas.so
test -f $LAPACK
test -f $BLAS
test -f $ATLAS


#export ATLAS=None
#export BLAS=None
#export LAPACK=None

$PYTHON setup.py install

