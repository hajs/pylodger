#!/bin/bash
make CC="gcc -I$PREFIX/include" -C src || bash -i
mkdir -p $PREFIX/bin
cp src/proot $PREFIX/bin

