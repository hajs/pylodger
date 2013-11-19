#!/bin/bash
./configure --prefix=$PREFIX
make
make install

echo '
PREFIX=$(dirname $(dirname $(readlink -f ${BASH_SOURCE[0]})))
export JED_ROOT=$PREFIX/jed/
'> $PREFIX/bin/set_env.jed
chmod +x $PREFIX/bin/set_env.jed
