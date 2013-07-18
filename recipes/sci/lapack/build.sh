# on Linux with lapack-3.2.1 or newer
bash -i
mkdir -p $PREFIX/lib

#cp INSTALL/make.inc.gfortran make.inc
cp make.inc.example make.inc
make lapacklib
#make clean
#export LAPACK=liblapack.a
#cp $LAPACK $PREFIX/lib

