#!/bin/bash
make && make 
mkdir -p $PREFIX/bin
cp src/unionfs $PREFIX/bin

