#!/bin/bash

mkdir -p $PREFIX/lib/python2.7/site-packages
cp -a fabric $PREFIX/lib/python2.7/site-packages/
mkdir -p $PREFIX/bin
echo "#!/opt/anaconda1anaconda2anaconda3/bin/python                                                                                   
from fabric.main import main                                                                                                          
main()                                                                                                                                
" > $PREFIX/bin/fabric
chmod +x $PREFIX/bin/fabric


#$PYTHON setup.py install

# Add more build steps here, if they are necessary.

# See
# https://github.com/ContinuumIO/conda/blob/master/conda/builder/README.txt
# for a list of environment variables that are set during the build process.
