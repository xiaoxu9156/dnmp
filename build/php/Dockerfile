ARG PHP_VERSION
FROM php:${PHP_VERSION}-fpm-alpine
ENV LANG C.UTF-8

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

# 复制启动命令
COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint
RUN chmod +x /usr/local/bin/docker-entrypoint

WORKDIR /app

ENTRYPOINT ["docker-entrypoint"]
