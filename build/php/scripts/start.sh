#!/bin/sh

set -x

# 开启crontab服务
crond

# 运行 php-fpm
php-fpm
