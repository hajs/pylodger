#!/bin/bash

#wget http://cairographics.org/releases/pixman-0.32.4.tar.gz
./configure --prefix=$PREFIX --disable-static

make && make install