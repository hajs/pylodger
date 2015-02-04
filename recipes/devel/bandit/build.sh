#!/bin/bash
$PYTHON setup.py install
mkdir -p $PREFIX/etc
cp bandit.yaml $PREFIX/etc
