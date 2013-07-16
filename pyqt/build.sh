export PATH=$SYS_PREFIX/bin:$PATH  # to find qmake
python configure.py --bindir $PREFIX/bin/ --destdir $PREFIX/lib/python2.7/site-packages/ --no-designer-plugin --sipdir $PREFIX/share/sip/PyQt4 --no-qsci-api --confirm-license
make
make install


