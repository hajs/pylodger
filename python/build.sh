./configure --enable-unicode=ucs4 --prefix=$PREFIX --enable-shared \
#                --infodir='${prefix}/share/info' \
#                --mandir='${prefix}/share/man' \
#                --with-libc="" \
#		--with-libm="" \
#                --enable-loadable-sqlite-extensions \


make
make install
