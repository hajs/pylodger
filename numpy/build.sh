#!/bin/sh
export LAPACK=$SYS_PREFIX/lib/liblapack.a
export BLAS=$SYS_PREFIX/lib/libblas.a

$PYTHON setup.py install

