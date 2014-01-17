#!/bin/bash

sed -i "s/'numpy>=1.7',//g" setup.py
sed -i "s/'dsltools',//g" setup.py
rm parakeet/transforms/parallelize_loops.py
rm parakeet/analysis/array_write_analysis.py
$PYTHON setup.py install

# Add more build steps here, if they are necessary.

# See
# http://docs.continuum.io/conda/build.html
# for a list of environment variables that are set during the build process.
