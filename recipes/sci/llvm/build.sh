#./configure --enable-optimized --prefix=$PREFIX
#REQUIRES_RTTI=1 make install

mkdir build
cd build
cmake -G "Unix Makefiles" -DCMAKE_INSTALL_PREFIX=$PREFIX ../
make
make install 
