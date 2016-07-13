#!/bin/bash
echo "post-linking conda"
rm -f $PREFIX/bin/conda
mkdir -p $PREFIX/bin
echo "#!/$PREFIX/bin/python
import sys
from conda.cli.main import main
sys.exit(main() or 0)
" > $PREFIX/bin/conda
chmod +x $PREFIX/bin/conda
