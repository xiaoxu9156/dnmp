ARG PHP_VERSION
FROM php:${PHP_VERSION}-fpm-bullseye
ENV LANG C.UTF-8
ENV PHP_COMPOSER_MIRROR=https://mirrors.aliyun.com/composer/

ARG PHP_EXTENSIONS
ARG SOURCES_MIRROR
ARG TZ

COPY ./extensions /tmp/extensions

RUN set -eux; \
    if [ "${SOURCES_MIRROR}" != "" ];  \
       then sed -i "s/deb.debian.org/${SOURCES_MIRROR}/g" /etc/apt/sources.list; \
    fi; \
    apt-get update; \
	apt-get install -y --no-install-recommends supervisor cron git unzip; \
	rm -rf /var/lib/apt/lists/*; \
    echo "${TZ}" > /etc/timezone; \
    ln -sf /usr/share/zoneinfo/${TZ} /etc/localtime; \
    # 安装拓展
    cp /tmp/extensions/install-php-extensions /usr/local/bin/; \
    chmod +x /usr/local/bin/install-php-extensions; \
    install-php-extensions ${PHP_EXTENSIONS}; \
    # 安装 composer
    curl -fsSL -o /usr/local/bin/composer ${PHP_COMPOSER_MIRROR}"composer.phar"; \
    chmod +x /usr/local/bin/composer; \
    composer config -g repo.packagist composer ${PHP_COMPOSER_MIRROR}; \
    # 设置启动命令
    cp /tmp/extensions/docker-entrypoint.sh /usr/local/bin/docker-entrypoint; \
    chmod +x /usr/local/bin/docker-entrypoint; \
    rm -rf /tmp/extensions; \
    # 修改 www-data 的 uid 和 gid，避免权限问题
    usermod -u 82 www-data && groupmod -g 82 www-data; \
    # 修改 openssl 配置文件解决curl请求时携带 ssl_cert 的报错
    sed -i 's/SECLEVEL=2/SECLEVEL=1/g' /etc/ssl/openssl.cnf;

WORKDIR /app

ENTRYPOINT ["docker-entrypoint"]
