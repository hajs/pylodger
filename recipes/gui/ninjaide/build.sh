#!/bin/bash


#$PYTHON setup.py install --prefix=$PREFIX
mkdir -p $PREFIX/lib/python2.7/site-packages
cp -a ninja_ide $PREFIX/lib/python2.7/site-packages
mkdir -p $PREFIX/bin
cp ninja-ide.py $PREFIX/bin

# Add more build steps here, if they are necessary.

# See
# http://docs.continuum.io/conda/build.html
# for a list of environment variables that are set during the build process.
