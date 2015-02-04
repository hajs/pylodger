#!/bin/bash

export PATH=/opt/centos/devtoolset-1.0/root/usr/bin:$PATH
export CFLAGS="-I$PREFIX/include -L$PREFIX/lib"
#-lpixman-1 -lfreetype -l
#export LDFLAGS=
ln -s $PREFIX/include/freetype2/freetype/ $PREFIX/include/

./configure                 \
    --prefix=$PREFIX        \
    --disable-static        \
    --enable-warnings       \
    --enable-ft             \
    --enable-ps             \
    --enable-pdf            \
    --enable-svg            \
    --disable-gtk-doc
make -k || true # || bash -i
make install -k || true 

rm -rf $PREFIX/share

# vim:set ts=8 sw=4 sts=4 tw=78 et:
