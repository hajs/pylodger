exit 0 # using blas built by atlas

mkdir -p $PREFIX/lib

#gfortran -O3 -std=legacy -m64 -fno-second-underscore -fPIC -c *.f    
#ar r libfblas.a *.o
#ranlib libfblas.a
#rm -rf *.o
#export BLAS=libfblas.a
#cp $BLAS $PREFIX/lib/

make all
