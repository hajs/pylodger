#!/bin/bash
$PYTHON setup.py install
##wget https://raw.github.com/pypa/pip/master/contrib/get-pip.py
##$PYTHON get-pip.py
##mkdir -p $PREFIX/bin
##echo "#!/bin/sh
##python -m pip $*
##" > $PREFIX/bin/pip
#echo "#!/opt/anaconda1anaconda2anaconda3/bin/python
#import sys
#from pip.runner import run
#sys.exit(run() or 0)
#" > $PREFIX/bin/pip
#chmod +x $PREFIX/bin/pip