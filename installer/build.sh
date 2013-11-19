#!/bin/bash
# Taken from http://www.linuxjournal.com/node/1005818
set -e -x
#if [ "$1" == "" ]
#then
#  SOURCE=$HOME/pylodger
#else
#  SOURCE=$1
#fi
SOURCE=/opt/pylodger # XXX: this path will be relocated inside payload/installer.sh
TARGET=pylodger-installer.sh
ROOT=$(readlink -f $(dirname $0))
cp $ROOT/../relocate.py $ROOT/payload/
echo "Using pylodger from $SOURCE. Press Ctrl-C to abort"
read
cd $SOURCE
echo "Removing no longer required files..."
rm -rf man ssl/man info share/man share/info share/readline conda-bld
rm -rf lib/python2.7/test/
strip bin/* || true
strip --strip-debug lib/*.so lib/python2.7/lib-dynload/*.so || true
cd pkgs
rm -rf *
cd ..
echo "Collecting files..."
tar cf $ROOT/payload/files.tar *
cd $ROOT/payload
echo "
Python-distribution for Conda
=============================

" > motd.txt
date >> motd.txt
hg id >> motd.txt
echo "Build by $USER@$HOSTNAME

" >> motd.txt
tar cf ../payload.tar *
cd ..
echo "Compressing..."
bzip2 payload.tar 
echo "Creating installer..."
cat decompress.template payload.tar.bz2 > $TARGET
chmod +x $TARGET
rm payload.tar.bz2
echo "Installer $TARGET successfully created"


