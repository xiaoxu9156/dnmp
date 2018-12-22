
FROM openjdk:8u181-jre-alpine3.8

# 复制jar包
COPY lib/ /app/

# 复制启动命令
COPY entrypoint.sh /usr/bin/entrypoint
RUN chmod +x /usr/bin/entrypoint

WORKDIR /app

EXPOSE 21230

ENTRYPOINT ["entrypoint"]
