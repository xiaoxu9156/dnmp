#!/bin/sh

echo "============================================"
echo "Building extensions for PHP"
echo "PHP Version           : ${PHP_VERSION}"
echo "Extra Extensions      : ${PHP_EXTENSIONS}"
echo "Work Directory        : ${PWD}"
echo "============================================"

# PHP拓展安装方法
installPHPExtensions() {
    # 初始化需安装的拓展及依赖
    exts_to_install=
    exts_deps=

    # 遍历参数里的拓展
    for ext; do
        if [ 1 -eq `php -m | grep ${ext} | wc -l` ]; then
            echo "${ext} was already installed"
            continue
        fi

        # 处理有特殊要求的拓展
        if [ 'gd' = ${ext} ]; then
            apk add --no-cache freetype-dev libjpeg-turbo-dev libpng-dev
            docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ --with-png-dir=/usr/include/
        fi

        if [ 'gettext' = ${ext} ]; then
            exts_deps="$exts_deps gettext-dev"
        fi

        if [ 'intl' = ${ext} ]; then
            exts_deps="$exts_deps icu-dev"
        fi

        if [ 'mcrypt' = ${ext} ]; then
            exts_deps="$exts_deps libmcrypt-dev"
        fi

        if [ 'pdo_pgsql' = ${ext} ]; then
            exts_deps="$exts_deps postgresql-dev"
        fi

        if [ 'soap' = ${ext} ]; then
            exts_deps="$exts_deps libxml2-dev"
        fi

        if [ 'xsl' = ${ext} ]; then
            exts_deps="$exts_deps libxslt-dev"
        fi

        if [ 'mongodb' = ${ext} ]; then
            mkdir mongodb \
            && tar -xf mongo-php-driver-1.5.3.tar.gz -C mongodb --strip-components=1 \
            && ( cd mongodb && phpize && ./configure  && make -j$(nproc) && make install ) \
            && docker-php-ext-enable mongodb
            continue
        fi

        if [ 'redis' = ${ext} ]; then
            mkdir redis \
            && tar -xf phpredis-4.1.1.tar.gz -C redis --strip-components=1 \
            && ( cd redis && phpize && ./configure && make -j$(nproc) && make install ) \
            && docker-php-ext-enable redis
            continue
        fi

        if [ 'swoole' = ${ext} ]; then
            mkdir swoole \
            && tar -xf swoole-src-4.4.12.tar.gz -C swoole --strip-components=1 \
            && ( cd swoole && phpize && ./configure && make -j$(nproc) && make install ) \
            && docker-php-ext-enable swoole
            continue
        fi

        exts_to_install="$exts_to_install $ext"
    done

    # 检查需安装的拓展
    if [ -z "${exts_to_install}" ]; then
        echo "---------- No More Extensions To Install ----------"
        return 0;
    fi

    # 安装依赖
    if [ -n "${exts_deps}" ]; then
        echo "Install Dependences: ${exts_deps}"
        apk add --no-cache ${exts_deps}
    fi

    # 安装拓展
    docker-php-ext-install -j$(nproc) ${exts_to_install}
}

installPHPExtensions ${PHP_EXTENSIONS//,/ }
