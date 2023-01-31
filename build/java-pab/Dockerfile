FROM openjdk:8u181-jre-alpine3.8

# 复制jar包
COPY lib/ /app/

# 复制启动命令
COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint
RUN chmod +x /usr/local/bin/docker-entrypoint

WORKDIR /app

ENTRYPOINT ["docker-entrypoint"]
