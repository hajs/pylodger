#!/bin/bash

#$PYTHON setup.py install
mkdir -p $PREFIX/lib/python2.7/site-packages
cp -a src/etcd $PREFIX/lib/python2.7/site-packages/
cp -a $PREFIX/lib/python2.7/site-packages/requests/packages/urllib3/ $PREFIX/lib/python2.7/site-packages/

# Add more build steps here, if they are necessary.

# See
# http://docs.continuum.io/conda/build.html
# for a list of environment variables that are set during the build process.
