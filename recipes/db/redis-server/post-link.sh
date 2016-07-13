mkdir -p $PREFIX/var/run
mkdir -p $PREFIX/var/lib/redis
mkdir -p $PREFIX/etc/supervisord.conf.d

cd $PREFIX/etc
if [ -f redis.conf ]
then
  echo "redis.conf already exists"
else
  sed -e "s,%PREFIX%,$PREFIX,g" < redis.conf.in > redis.conf
fi

cd supervisord.conf.d
if [ -f redis.conf ]
then
  echo "supervisor-redis.conf already exists"
else
  sed -e "s,%PREFIX%,$PREFIX,g" < redis.conf.in > redis.conf
fi
