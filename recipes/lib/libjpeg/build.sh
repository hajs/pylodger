./configure --prefix=$PREFIX
make
mkdir -p $PREFIX/{bin,lib,include,man/man1}
make install
