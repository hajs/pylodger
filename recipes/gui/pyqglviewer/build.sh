export LD_FLAGS="$LD_FLAGS -lGLU"
PREFIX=$PREFIX python configure.py && PREFIX=$PREFIX make && PREFIX=$PREFIX make install 


