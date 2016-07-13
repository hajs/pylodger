#!/bin/bash
mkdir -p $PREFIX/var/log/supervisord
mkdir -p $PREFIX/var/run
mkdir -p $PREFIX/etc/supervisord.conf.d
if [ -f "$PREFIX/etc/supervisord.conf" ]
then
  echo "$PREFIX/etc/supervisord.conf already exists"
else
  sed -e "s,%PREFIX%,$PREFIX,g" \
      < $PREFIX/etc/supervisord.conf.in \
      > $PREFIX/etc/supervisord.conf
fi
