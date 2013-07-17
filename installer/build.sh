#!/bin/bash
# Taken from http://www.linuxjournal.com/node/1005818
cd $(readlink -f $(dirname $0))

cd payload
tar cf ../payload.tar /opt/freeconda
cd ..

if [ -e "payload.tar" ]; then
    gzip payload.tar
    
    if [ -e "payload.tar.gz" ]; then
       cat decompress.template payload.tar.gz > freeconda-installer.sh
       chmod +x freeconda-installer.sh
       exit 0
    else
       echo "payload.tar.gz does not exist"
       exit 1
    fi
else
    echo "payload.tar does not exist"
    exit 1
fi
