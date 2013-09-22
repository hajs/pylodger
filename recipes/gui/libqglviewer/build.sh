export LD_FLAGS="$LD_FLAGS -lGLU"
cd QGLViewer
qmake PREFIX=$PREFIX
make
make install


