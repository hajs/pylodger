#!/bin/bash

replace "/usr/share/ansible/" "$PREFIX/share/ansible/" -- lib/ansible/constants.py
$PYTHON setup.py install --prefix=$PREFIX

# Add more build steps here, if they are necessary.

# See
# https://github.com/ContinuumIO/conda/blob/master/conda/builder/README.txt
# for a list of environment variables that are set during the build process.
