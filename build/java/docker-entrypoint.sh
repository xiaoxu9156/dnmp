#!/bin/sh

set -ex

lib=/app
classpath=.

for file in ${lib}/*.jar;
    do classpath=${classpath}:$file;
done

# LAJP服务启动指令(前台)
java -classpath $classpath lajpsocket.PhpJava
