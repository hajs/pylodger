unset QT_PLUGIN_PATH
export CMAKE_MODULE_PATH=$PREFIX/share/cmake-2.8/Modules/
mkdir build
cd build
cmake  \
    -DQTC_QT4_ENABLE_KDE=Off -DQTC_QT4_ENABLE_KWIN=Off \
    -DCMAKE_INSTALL_PREFIX=$PREFIX \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_INSTALL_RPATH=$LD_RUN_PATH \
    -DLIB_INSTALL_DIR=$PREFIX/lib \
    ..
make
make install

