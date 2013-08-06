#!/bin/bash

#$PYTHON setup.py install
cp -a brain/ $PREFIX/lib/python2.7/site-packages/astroid/brain

# Add more build steps here, if they are necessary.

# See
# https://github.com/ContinuumIO/conda/blob/master/conda/builder/README.txt
# for a list of environment variables that are set during the build process.
