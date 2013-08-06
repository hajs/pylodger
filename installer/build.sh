#!/bin/bash
# Taken from http://www.linuxjournal.com/node/1005818
set -e
SOURCE=/opt/pylodger
TARGET=pylodger-installer.sh
ROOT=$(readlink -f $(dirname $0))
cd $SOURCE
echo "Removing no longer required files..."
rm -rf man ssl/man info share/man share/info share/readline conda-bld
rm -rf lib/python2.7/test/
cd pkgs
rm -rf *
cd ..
echo "Collecting files..."
tar cf $ROOT/payload/files.tar *
cd $ROOT/payload
cp ../../relocate.py .
tar cf ../payload.tar *
cd ..
echo "Compressing..."
bzip2 payload.tar 
echo "Creating installer..."
cat decompress.template payload.tar.bz2 > $TARGET
chmod +x $TARGET
rm payload.tar.bz2
echo "Installer $TARGET successfully created"
 