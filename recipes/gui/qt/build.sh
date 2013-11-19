#!/bin/bash
export PATH=/opt/centos/devtoolset-1.0/root/usr/bin:$PATH

# http://qt-project.org/doc/qt-4.8/configure-options.html
chmod +x configure

./configure \
        -dbus -svg \
        -qt-libjpeg \
        -release -fontconfig -verbose \
        -no-qt3support -nomake examples -nomake demos \
        -qt-libpng -qt-zlib \
        -webkit \
        -prefix $PREFIX 

make 
make install

cp $SRC_DIR/bin/* $PREFIX/bin/
cd $PREFIX
#rm -rf doc imports phrasebooks plugins q3porting.xml translations
rm -rf doc imports phrasebooks q3porting.xml translations
cd $PREFIX/bin
#mv ../plugins/* bin
#rmdir ../plugins
rm -f *.bat *.pl qt3to4 qdoc3
echo "[Paths]
prefix=../
#headers=../include/
#plugins=../plugins/
#translations=../translations/
#mkspecs=../mkspecs/
#libraries=../libs/

#[SDK]
#fixupRelativePrefixDefault=1

" > $PREFIX/bin/qt.conf

echo "unset QT_PLUGIN_PATH" > $PREFIX/bin/set_env.disable_kde
chmod +x $PREFIX/bin/set_env.disable_kde

echo "
[qt]
style=QtCurve
" > $PREFIX/Trolltech.conf
