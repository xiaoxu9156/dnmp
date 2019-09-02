FROM node:12.3.1-alpine as builder

ARG YAPI_VERSION
ARG ALPINE_REPOSITORIES
ARG NPM_REGISTRY

ENV YAPI_SOURCE=http://registry.npm.taobao.org/yapi-vendor/download/yapi-vendor-{version}.tgz

RUN if [ "${ALPINE_REPOSITORIES}" != "" ]; then \
        sed -i "s/dl-cdn.alpinelinux.org/${ALPINE_REPOSITORIES}/g" /etc/apk/repositories; \
    fi \
    #&& apk --no-cache add git python make openssl tar gcc \
    && if [ "${NPM_REGISTRY}" != "" ]; then \
        npm config set registry ${NPM_REGISTRY}; \
    fi \
    && mkdir -p /api/vendors \
    && cd /api \
    && YAPI_SOURCE=${YAPI_SOURCE/"{version}"/"${YAPI_VERSION}"} \
    && wget -O yapi.tgz "${YAPI_SOURCE}" \
    && tar -xf yapi.tgz -C vendors  --strip-components=1 \
    && cd vendors \
	&& npm install --production

FROM node:12.3.1-alpine

LABEL maintainer=zhangxiaoxu
ENV LANG C.UTF-8

ARG ALPINE_REPOSITORIES
ARG TZ
ARG YAPI_PORT
ARG ADMIN_ACCOUNT
ARG DB_SERVER
ARG DB_NAME
ARG DB_PORT

COPY --from=builder /api/vendors /api/vendors
COPY config.json /api/
COPY docker-entrypoint.sh /usr/local/bin/

RUN if [ "${ALPINE_REPOSITORIES}" != "" ]; then \
        sed -i "s/dl-cdn.alpinelinux.org/${ALPINE_REPOSITORIES}/g" /etc/apk/repositories; \
    fi \
    && apk --no-cache add tzdata \
    && cp "/usr/share/zoneinfo/$TZ" /etc/localtime \
    && echo "$TZ" > /etc/timezone \
    && sed -i "s/__YAPI_PORT__/"${YAPI_PORT}"/g" /api/config.json \
	&& sed -i "s/__ADMIN_ACCOUNT__/"${ADMIN_ACCOUNT}"/g" /api/config.json \
	&& sed -i "s/__DB_SERVER__/"${DB_SERVER}"/g" /api/config.json \
	&& sed -i "s/__DB_NAME__/"${DB_NAME}"/g" /api/config.json \
	&& sed -i "s/__DB_PORT__/"${DB_PORT}"/g" /api/config.json \
    && chmod +x /usr/local/bin/docker-entrypoint.sh

WORKDIR /api/vendors

ENTRYPOINT ["docker-entrypoint.sh"]
