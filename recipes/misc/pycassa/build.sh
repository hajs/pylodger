#!/bin/bash
#rm ez_setup.py
mkdir -p $PREFIX/lib/python2.7/site-packages/
cp -a pycassa $PREFIX/lib/python2.7/site-packages/
#$PYTHON setup.py install --prefix=$PREFIX

# Add more build steps here, if they are necessary.

# See
# https://github.com/ContinuumIO/conda/blob/master/conda/builder/README.txt
# for a list of environment variables that are set during the build process.
