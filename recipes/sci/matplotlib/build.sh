#!/bin/sh
ln -sf $PREFIX/include/freetype2/freetype /usr/local/include/
$PYTHON setup.py install #|| bash -i

