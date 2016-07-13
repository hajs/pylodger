#!/bin/bash
set -e

mkdir -p $PREFIX/etc/supervisord.conf.d
cp $RECIPE_DIR/redis.conf $PREFIX/etc/redis.conf.in
cp $RECIPE_DIR/redis-supervisord.conf $PREFIX/etc/supervisord.conf.d/redis.conf.in



env -i PATH=$PATH PREFIX=$PREFIX make
env -i PATH=$PATH PREFIX=$PREFIX make install

cd deps
make hiredis jemalloc linenoise lua || bash -i
cd ..
make
make install

		