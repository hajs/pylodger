#! /bin/bash

set -e
./configure --prefix=$PREFIX || { cat config.log ; exit 1 ; }
cp config.log /tmp/
make
make install
