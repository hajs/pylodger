#!/bin/bash
export PATH=/opt/centos/devtoolset-1.0/root/usr/bin:$PATH

chmod +x configure

./configure \
        -prefix $PREFIX

make 
make install

cp $SRC_DIR/bin/* $PREFIX/bin/
cd $PREFIX
