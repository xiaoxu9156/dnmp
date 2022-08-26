ARG PHP_VERSION
FROM php:${PHP_VERSION}-fpm-alpine
ENV LANG C.UTF-8
ENV PHP_COMPOSER_MIRROR=https://mirrors.aliyun.com/composer/

ARG TZ
ARG PHP_EXTENSIONS
ARG ALPINE_REPOSITORIES

COPY ./extensions /tmp/extensions

RUN if [ "${ALPINE_REPOSITORIES}" != "" ]; then \
        sed -i "s/dl-cdn.alpinelinux.org/${ALPINE_REPOSITORIES}/g" /etc/apk/repositories; \
    fi \
    && apk --no-cache add supervisor tzdata git \
    && cp "/usr/share/zoneinfo/$TZ" /etc/localtime \
    && echo "$TZ" > /etc/timezone \
    # 安装拓展
    && cp /tmp/extensions/install-php-extensions /usr/local/bin/ \
    && chmod +x /usr/local/bin/install-php-extensions \
    && install-php-extensions ${PHP_EXTENSIONS} \
    # 安装 composer
    && cp /tmp/extensions/composer.phar /usr/local/bin/composer \
    && chmod +x /usr/local/bin/composer \
    && composer config -g repo.packagist composer ${PHP_COMPOSER_MIRROR} \
    # 设置启动命令
    && cp /tmp/extensions/docker-entrypoint.sh /usr/local/bin/docker-entrypoint \
    && chmod +x /usr/local/bin/docker-entrypoint \
    && rm -rf /tmp/extensions

ENV LD_PRELOAD /usr/lib/preloadable_libiconv.so php

WORKDIR /app

ENTRYPOINT ["docker-entrypoint"]
