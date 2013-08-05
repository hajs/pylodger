#!/bin/bash
$PYTHON setup.py install
#wget https://raw.github.com/pypa/pip/master/contrib/get-pip.py
#$PYTHON get-pip.py
mkdir -p $PREFIX/bin
echo "#!/bin/sh
python -m pip $*
" > $PREFIX/bin/pip
chmod +x $PREFIX/bin/pip