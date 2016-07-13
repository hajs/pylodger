#!/bin/sh
mkdir -p $PREFIX/lib/yed
cp -av * $PREFIX/lib/yed/
mkdir -p $PREFIX/bin
echo '#!/bin/sh
PREFIX=$(dirname $(dirname $(readlink -f ${BASH_SOURCE[0]})))
cd $PREFIX/lib/yed
java -jar yed.jar "$@"
' > $PREFIX/bin/yed
chmod +x $PREFIX/bin/yed

