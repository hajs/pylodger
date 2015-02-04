#!/bin/bash

rm -rf test
mkdir test
touch test/tests_removed_because_of_errors.py
$PYTHON setup.py install --prefix=$PREFIX || true


# Add more build steps here, if they are necessary.

# See
# http://docs.continuum.io/conda/build.html
# for a list of environment variables that are set during the build process.
