#!/bin/bash

#$PYTHON setup.py install --prefix=$PREFIX
mkdir -p $PREFIX/lib/python2.7/site-packages
cp python2/pyinotify.py $PREFIX/lib/python2.7/site-packages


# Add more build steps here, if they are necessary.

# See
# http://docs.continuum.io/conda/build.html
# for a list of environment variables that are set during the build process.
