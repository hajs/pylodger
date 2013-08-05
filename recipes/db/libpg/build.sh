./configure --prefix=$PREFIX --without-readline
make

cd src/interfaces/libpq
make install

cd ../..
cd bin/pg_config
make install

cd ../../
cd include
make install
