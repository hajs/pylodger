#!/bin/bash
# http://www.cmake.org/pipermail/cmake/2008-January/019290.html
#export LDFLAGS='-Wl,-rpath=$ORIGIN/../lib'
CC=cc CXX=c++ ./configure --prefix=$PREFIX
make
rm $SRC_DIR/Modules/CPack.OSXScriptLauncher.in
make install
