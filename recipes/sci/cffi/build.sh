#!/bin/bash

# include copy
mkdir -p $PREFIX/lib/
cp /usr/lib64/libffi.so.5 $PREFIX/lib/

$PYTHON setup.py install

# Add more build steps here, if they are necessary.

# See
# http://docs.continuum.io/conda/build.html
# for a list of environment variables that are set during the build process.
