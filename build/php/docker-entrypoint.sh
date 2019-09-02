#!/bin/sh

set -ex

# 开启crontab服务
crond

# 开启supervisor服务
supervisord -c /etc/supervisord.conf

# 运行 php-fpm
php-fpm
