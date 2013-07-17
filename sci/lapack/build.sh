# on Linux with lapack-3.2.1 or newer
cp INSTALL/make.inc.gfortran make.inc          
make lapacklib
make clean
mkdir -p $PREFIX/lib
export LAPACK=liblapack.a
cp $LAPACK $PREFIX/lib

