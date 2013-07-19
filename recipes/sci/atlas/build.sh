#/bin/sh
set -e

# Adapted from http://trac.sagemath.org/attachment/ticket/9600/make_correct_shared.sh
SIZE="64-bit "
: ${CFLAG64:=-m64}
ARDIR=artmp.$$

relink() {
    LIB="$1"
    shift
    echo "Building ${SIZE}shared library lib${LIB}.so from static lib${LIB}.a"
    rm -fr $ARDIR
    mkdir $ARDIR
    cd $ARDIR
    ar -x ../lib${LIB}.a
    ${CC:-gcc} $CFLAG64 -shared *.o -o ../lib${LIB}.so "-L$PREFIX/lib" -lm "$@"
    cd ..
    rm -fr $ARDIR
}



mkdir build
cd build
../configure --with-netlib-lapack-tarfile=$SYS_PREFIX/conda-bld/src_cache/lapack.tgz --shared  -Fa alg '-fPIC'
make 
cd lib

make shared cshared ptshared cptshared
#gcc -shared -o liblapack.so -Wl,-soname,liblapack.so -Wl,--whole-archive liblapack.a -Wl,--no-whole-archive -lgfortran -lm
relink atlas
relink cblas
relink f77blas "-lgfortran"
relink ptcblas
relink ptf77blas "-lgfortran"
relink lapack  "-lgfortran"


mkdir -p $PREFIX/lib
cp -v lib* $PREFIX/lib

