#!/bin/bash

./configure --prefix=$PREFIX #--enable-utf8
make
make install
