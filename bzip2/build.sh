make -f Makefile-libbz2_so 
mkdir -p $PREFIX/lib
mv libbz2.so.* $PREFIX/lib
#make install PREFIX=$PREFIX
