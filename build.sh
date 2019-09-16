#!/usr/bin/env bash

export DRUSH_9_VER=9.6.2
export DRUSH_8_VER=8.2.3
export COMPOSER_VER=1.8.5
export PHP_VERSION=5.6
export MEMCACHED_VERSION="-2.2.0"
export XDEBUG_VERSION="-2.5.5"

envsubst '${DRUSH_9_VER},${DRUSH_8_VER},${COMPOSER_VER},${PHP_VERSION},${MEMCACHED_VERSION}${XDEBUG_VERSION}' < Dockerfile.tpl > Dockerfile
docker build -t droptica/php-dev:${PHP_VERSION} .

export MEMCACHED_VERSION=''
export XDEBUG_VERSION=''
for i in $(seq 1 3); do
    export PHP_VERSION=7.${i}
    envsubst '${DRUSH_9_VER},${DRUSH_8_VER},${COMPOSER_VER},${PHP_VERSION},${MEMCACHED_VERSION}${XDEBUG_VERSION}' < Dockerfile.tpl > Dockerfile
    docker build -t droptica/php-dev:${PHP_VERSION} .
done

rm Dockerfile
