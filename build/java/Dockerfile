
FROM openjdk:8u181-jre-alpine3.8

# 复制jar包及命令
COPY lib/ /app/
COPY entrypoint.sh /usr/bin/entrypoint

WORKDIR /app

EXPOSE 21230

ENTRYPOINT ["entrypoint"]
