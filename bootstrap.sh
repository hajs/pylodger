#!/bin/bash
set -e
if [ -d /opt/anaconda ]
then
  echo "anaconda found"
else
  echo "Please install Anaconda to /opt/anaconda"
  wget http://repo.continuum.io/miniconda/Miniconda-1.6.2-Linux-x86_64.sh
  sh Miniconda-1.6.2-Linux-x86_64.sh
fi
test -d /opt/anaconda || exit 1
./build_base.sh /opt/anaconda /tmp/interim_conda
./build_base.sh /tmp/interim_conda /opt/pylodger
