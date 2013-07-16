export CFLAGS=-I${SYS_PREFIX}/include 
export CPPFLAGS=-I${SYS_PREFIX}/include 
export LDFLAGS=-L${SYS_PREFIX}/lib
export SSL=${SYS_PREFIX}

#./configure --enable-unicode=ucs4 --prefix=${SYS_PREFIX} --enable-shared
./configure --enable-unicode=ucs4 --prefix=$PREFIX --enable-shared \
#                --infodir='${prefix}/share/info' \
#                --mandir='${prefix}/share/man' \
#                --with-libc="" \
#		--with-libm="" \
#                --enable-loadable-sqlite-extensions \

make
make install
#make install DESTDIR=$PREFIX
