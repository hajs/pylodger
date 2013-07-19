cmake -DCMAKE_INSTALL_PREFIX=$PREFIX -DBUILD_SHARED_LIBS:bool=on .
make
make install
cd $PREFIX/lib
test -f libopenjpeg.so || ln -s libopenjp2.so.2.0.0 libopenjpeg.so
