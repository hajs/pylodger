#!/bin/bash
mkdir -p $PREFIX/bin $PREFIX/etc
pwd
cp -v usr/bin/* $PREFIX/bin 
cp etc/influxdb/influxdb.conf $PREFIX/etc/  
cp $PREFIX/etc/influxdb.conf /tmp

