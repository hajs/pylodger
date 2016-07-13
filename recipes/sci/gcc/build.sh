#!/bin/bash
./contrib/download_prerequisites
cd ..
mkdir build
cd build
../gcc-4.8.2/configure --prefix=$HOME/toolchains --enable-languages=c,c++ 
make -j$(nproc)
make install
