#!/bin/sh
set -eu

export BACKEND_HOST="${BACKEND_HOST:-backend}"
export CMS_UPSTREAM="${CMS_UPSTREAM:-http://bereich-b:3000}"

envsubst '${BACKEND_HOST} ${CMS_UPSTREAM}' < /app/default.conf.template > /etc/nginx/conf.d/default.conf

mkdir -p /var/run
spawn-fcgi -s /var/run/fcgiwrap.socket -M 0666 -F 1 -- /usr/bin/fcgiwrap

exec nginx -g 'daemon off;'
