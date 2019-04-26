#!/usr/bin/env bash

if [[ ! -z ${DRUSH_9+x} ]]; then
    export PATH=$(echo $PATH | sed -e 's;:\?/root/drush-8/vendor/bin;;')
    export PATH="/root/drush-9/vendor/bin:${PATH}"

fi

drush init -y > /dev/null 2>&1

exec "$@"