#!/bin/bash
#./autogen.sh
./configure --prefix=$PREFIX
make
make install

echo '
PREFIX=$(dirname $(dirname $(readlink -f ${BASH_SOURCE[0]})))
export TERMINFO=$PREFIX/share/terminfo/
'> $PREFIX/bin/set_env.tmux
chmod +x $PREFIX/bin/set_env.tmux
