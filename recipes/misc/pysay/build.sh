#!/bin/bash

$PYTHON setup.py install
cp -f /usr/share/cowsay/cows/* $PREFIX/share/cows/ # copy from cowsay if installed
# Add more build steps here, if they are necessary.

# See
# http://docs.continuum.io/conda/build.html
# for a list of environment variables that are set during the build process.
