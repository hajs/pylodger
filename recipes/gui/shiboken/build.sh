#!/bin/bash
# http://around-the-corner.typepad.com/adn/2012/10/building-qt-pyqt-pyside-for-maya-2013-part-2.html

mkdir build
cd build
cmake \
    -DCMAKE_INSTALL_PREFIX=$PREFIX \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_INSTALL_RPATH=$LD_RUN_PATH \
    -DQT_QMAKE_EXECUTABLE=$PREFIX/bin/qmake \
    -DPYTHON_EXECUTABLE=$PYTHON \
    -DLIB_INSTALL_DIR=$PREFIX/lib \
    -DPYTHON_INCLUDE_PATH=$PREFIX/include/python2.7 \
    -DPYTHON_LIBRARY=$PREFIX/lib/libpython2.7.so \
    ..
make VERBOSE=2
make install
