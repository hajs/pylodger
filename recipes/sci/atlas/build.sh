mkdir build
cd build
../configure --with-netlib-lapack-tarfile=$SYS_PREFIX/conda-bld/src_cache/lapack.tgz --shared y -Fa alg '-fPIC'
make 
cd lib
mkdir -p $PREFIX/lib
cp -v lib* $PREFIX/lib
