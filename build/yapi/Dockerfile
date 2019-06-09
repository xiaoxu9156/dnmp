FROM node:12.3.1-alpine as builder

# apk mirror
RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories
RUN apk update && apk add --no-cache git python make openssl tar gcc
ADD yapi.tgz /home/
RUN mkdir /api && mv /home/package /api/vendors
RUN cd /api/vendors && \
    npm install --production --registry https://registry.npm.taobao.org

FROM node:12.3.1-alpine

LABEL maintainer=zhangxiaoxu
ENV LANG C.UTF-8

RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories
RUN apk update && apk add --no-cache tzdata && cp /usr/share/zoneinfo/PRC /etc/localtime

COPY --from=builder /api/vendors /api/vendors
COPY config.json /api/
COPY docker-entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-entrypoint.sh
EXPOSE 3000
WORKDIR /api/vendors

ENTRYPOINT ["docker-entrypoint.sh"]
