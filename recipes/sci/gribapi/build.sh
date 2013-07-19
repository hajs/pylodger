export CFLAGS="-O2 -fPIC -I$PREFIX/include/openjpeg-1.5"
#export CFLAGS="-O2 -fPIC -I$PREFIX/include/openjpeg-2.0"
#export CFLAGS="-O2 -fPIC"

export GRIBAPI_DIR=$PREFIX
export JASPER_DIR=$PREFIX
#export OPENJPEG_DIR=$PREFIX
export PNG_DIR=$PREFIX


#./configure --prefix=$PREFIX --enable-python --with-openjpeg=$OPENJPEG_DIR 
./configure --prefix=$PREFIX --enable-python --with-jasper=$JASPER_DIR
#./configure --prefix=$PREFIX --enable-python --disable-jpeg
make
#make check
make install

