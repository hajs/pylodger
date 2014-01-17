#!/bin/bash
sed -i 's/long_description/zip_safe=False,long_description/g' setup.py 
$PYTHON setup.py install

# Add more build steps here, if they are necessary.

# See
# http://docs.continuum.io/conda/build.html
# for a list of environment variables that are set during the build process.
