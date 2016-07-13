#!/bin/bash

$PYTHON setup.py install
mkdir -p $PREFIX/etc
cp $RECIPE_DIR/supervisord.conf $PREFIX/etc/supervisord.conf.in

