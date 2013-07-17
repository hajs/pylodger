# http://www.linuxfromscratch.org/lfs/view/development/chapter06/ncurses.html
./configure --prefix=$PREFIX -with-shared      --without-debug  --enable-pc-files  #--enable-widec
make
make install
