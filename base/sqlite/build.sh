export LDFLAGS=-L${SYS_PREFIX}/lib
export CFLAGS=-I${SYS_PREFIX}/include
./configure --prefix=$PREFIX
#bash -i
make
make install
