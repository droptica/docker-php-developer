#!/usr/bin/env bash

if [[ ! -z ${DRUSH-9+x} ]]; then
    export PATH="/root/drush-9/vendor/bin:${PATH}"
else
    export PATH="/root/drush-8/vendor/bin:${PATH}"
fi

drush init -y > /dev/null 2>&1

exec "$@"