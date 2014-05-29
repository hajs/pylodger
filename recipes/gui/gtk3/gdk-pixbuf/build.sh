#! /bin/bash
set -e
#export JASPER_DIR=$PREFIX
#export OPENJPEG_DIR=$PREFIX
#export PNG_DIR=$PREFIX
export LIBRARY_PATH=$PREFIX/lib
export CPATH=$PREFIX/include:$CPATH
export CPPFLAGS=-I$PREFIX/include 
export LDFLAGS=-L$PREFIX/lib

./configure --x-includes=$PREFIX_DIR/include --x-libraries=$PREFIX_DIR/lib \
   --without-libtiff --prefix=$PREFIX # || { cat config.log ; exit 1 ; }
make
make install
