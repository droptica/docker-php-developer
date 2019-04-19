#!/usr/bin/env bash

if [[ ! -z ${DRUSH_9+x} ]]; then
    mv ~/drush-9 /usr/bin/drush
else
    mv ~/drush-8 /usr/bin/drush
fi

drush init -y

exec "$@"