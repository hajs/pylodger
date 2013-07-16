#!/bin/bash
set -e
./build_base.sh /opt/anaconda /tmp/interim_conda
./build_base.sh /tmp/interim_conda /opt/freeconda
