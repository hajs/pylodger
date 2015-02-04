#!/bin/bash

rm setup.cfg # setup.cfg sets installation path to /opt/graphite
find -name "urls.py" -exec sed -i 's/django.conf.urls.defaults/django.conf.urls/g' {} \;
$PYTHON setup.py install
# Add more build steps here, if they are necessary.

# See
# http://docs.continuum.io/conda/build.html
# for a list of environment variables that are set during the build process.
