ARG PHP_VERSION
FROM php:${PHP_VERSION}-fpm-alpine
ENV LANG C.UTF-8
ENV PHP_COMPOSER_MIRROR=https://mirrors.aliyun.com/composer/

ARG TZ
ARG PHP_EXTENSIONS
ARG ALPINE_REPOSITORIES

RUN if [ "${ALPINE_REPOSITORIES}" != "" ]; then \
        sed -i "s/dl-cdn.alpinelinux.org/${ALPINE_REPOSITORIES}/g" /etc/apk/repositories; \
    fi \
    && apk --no-cache add supervisor tzdata \
    && cp "/usr/share/zoneinfo/$TZ" /etc/localtime \
    && echo "$TZ" > /etc/timezone

COPY ./extensions /tmp/extensions
WORKDIR /tmp/extensions

RUN chmod +x install.sh \
    && /bin/sh install.sh \
    && rm -rf /tmp/extensions

ENV LD_PRELOAD /usr/lib/preloadable_libiconv.so php

WORKDIR /root

# 复制启动命令和安装composer
COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint
RUN chmod +x /usr/local/bin/docker-entrypoint \
    && wget -O /usr/local/bin/composer ${PHP_COMPOSER_MIRROR}"composer.phar" \
    && chmod +x /usr/local/bin/composer \
    && composer config -g repo.packagist composer ${PHP_COMPOSER_MIRROR}

WORKDIR /app

ENTRYPOINT ["docker-entrypoint"]
