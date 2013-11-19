#!/bin/bash
source /opt/centos/devtoolset-1.0/enable
./autogen.sh 
./configure --prefix=$PREFIX --with-screen=slang --without-x 
make 
make install
