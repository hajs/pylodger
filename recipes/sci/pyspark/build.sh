#!/bin/bash

TARGET=$PREFIX/lib/python2.7/site-packages
mkdir -p $TARGET

cd python/lib
unzip py4j-0.9-src.zip 
python -m compileall py4j
cp -a py4j $TARGET/

unzip pyspark.zip
python -m compileall pyspark
cp -a pyspark $TARGET/

