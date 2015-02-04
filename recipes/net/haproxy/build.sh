#!/bin/bash
make TARGET=custom USE_OPENSSL=1 USE_ZLIB=1 USE_LINUX_TPROXY=1 USE_LINUX_SPLICE=1 USE_PCRE=1   # CPU=native
strip haproxy
make PREFIX=$PREFIX SBINDIR=$PREFIX/bin install


