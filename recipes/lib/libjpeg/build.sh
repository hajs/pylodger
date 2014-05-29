#!/bin/sh
ln -svf $(which libtool) .
./configure --prefix=$PREFIX --enable-shared
make
mkdir -p $PREFIX/{bin,lib,include,man/man1}
make install
