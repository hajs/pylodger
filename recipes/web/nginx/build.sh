#!/bin/bash

./configure --prefix=$PREFIX --with-pcre=$PREFIX
make
make install

echo '#!/bin/bash
PREFIX=$(dirname $(dirname $(readlink -f $0)))
$PREFIX/sbin/nginx.real -p $PREFIX $*
' > $PREFIX/bin/nginx
chmod +x $PREFIX/bin/nginx

mv $PREFIX/sbin/nginx $PREFIX/sbin/nginx.real

mkdir -p $PREFIX/etc
mv $PREFIX/conf $PREFIX/etc/nginx


