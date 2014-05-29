#! /bin/bash
python ./waf configure --prefix=$PREFIX --libdir=$PREFIX/lib
python ./waf build
python ./waf install
		   
#./configure --prefix=$PREFIX 
#make
#make install

