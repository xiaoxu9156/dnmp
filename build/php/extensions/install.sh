#!/bin/sh

echo "============================================"
echo "Building extensions for PHP"
echo "============================================"

cd /tmp

mkdir redis \
&& tar -xf phpredis-4.1.1.tar.gz -C redis --strip-components=1 \
&& ( cd redis && phpize && ./configure && make && make install && make test) \
&& docker-php-ext-enable redis

mkdir mongodb \
&& tar -xf mongo-php-driver-1.5.3.tar.gz -C mongodb --strip-components=1 \
&& ( cd mongodb && phpize && ./configure && make && make install && make test) \
&& docker-php-ext-enable mongodb
