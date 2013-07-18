#!/bin/sh
#export LAPACK=$PREFIX/lib/liblapack.a
#export BLAS=$PREFIX/lib/libfblas.a

export ATLAS=None
export BLAS=None
export LAPACK=None

$PYTHON setup.py install

