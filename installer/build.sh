#!/bin/bash
# Taken from http://www.linuxjournal.com/node/1005818
set -e
ROOT=$(readlink -f $(dirname $0))
cd $ROOT

echo "Collecting files..."
cd /opt/freeconda
rm -rf man ssl/man info share/man share/info share/readline conda-bld
cd pkgs
rm -rf *
cd ..
tar cvf $ROOT/payload/files.tar *
cd $ROOT/payload
tar cf ../payload.tar *
cd ..
echo "Compressing..."
bzip2 payload.tar 
echo "Creating installer..."
cat decompress.template payload.tar.bz2 > freeconda-installer.sh
chmod +x freeconda-installer.sh
rm payload.tar.bz2
echo "Installed successfully created"
 