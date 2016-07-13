#!/bin/bash
mkdir -p $PREFIX/bin $PREFIX/grafana
cp -av * $PREFIX/grafana/
echo '#!/bin/bash
HERE=$(dirname $(readlink -f $0))
cd $HERE/../grafana/
./bin/grafana-server "$@"
' > $PREFIX/bin/grafana
chmod +x $PREFIX/bin/grafana


