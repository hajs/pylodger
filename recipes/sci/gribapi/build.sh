export CFLAGS="-O2 -fPIC -I$PREFIX/include/openjpeg-1.5"
#export CFLAGS="-O2 -fPIC -I$PREFIX/include/openjpeg-2.0"
#export CFLAGS="-O2 -fPIC"

export GRIBAPI_DIR=$PREFIX
export JASPER_DIR=$PREFIX
export OPENJPEG_DIR=$PREFIX
export PNG_DIR=$PREFIX

##./configure --prefix=$PREFIX --enable-python --disable-jpeg
##./configure --prefix=$PREFIX --enable-python --with-openjpeg=$OPENJPEG_DIR 
#./configure --prefix=$PREFIX --enable-python --with-jasper=$JASPER_DIR --enable-shared
./configure --prefix=$PREFIX --datarootdir=$PREFIX/share/grib_api/ --datadir=$PREFIX/share/grib_api/ --enable-python --with-jasper=$JASPER_DIR --enable-shared

make
#make check
make install

echo '
PREFIX=$(dirname $(dirname $(readlink -f ${BASH_SOURCE[0]})))
export GRIB_DEFINITION_PATH=$PREFIX/share/grib_api/definitions/
'> $PREFIX/bin/set_env.gribapi 
chmod +x $PREFIX/bin/set_env.gribapi

