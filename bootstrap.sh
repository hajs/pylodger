#!/bin/bash
set -e
if [ -d /opt/anaconda ]
then
  echo "anaconda found"
else
  echo "installing anaconda"
  wget http://09c8d0b2229f813c1b93-c95ac804525aac4b6dba79b00b39d1d3.r79.cf1.rackcdn.com/Anaconda-1.6.1-Linux-x86_64.sh
  sh Anaconda-1.6.1-Linux-x86_64.sh
fi
test -d /opt/anaconda || exit 1
./build_base.sh /opt/anaconda /tmp/interim_conda
./build_base.sh /tmp/interim_conda /opt/freeconda
