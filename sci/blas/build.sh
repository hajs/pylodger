# with gfortran
gfortran -O3 -std=legacy -m64 -fno-second-underscore -fPIC -c *.f    
ar r libfblas.a *.o
ranlib libfblas.a
rm -rf *.o
export BLAS=libfblas.a
mkdir -p $PREFIX/lib
cp $BLAS $PREFIX/lib/
