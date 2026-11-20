#!/bin/sh
set -eu

: "${STELE_BACKEND_ORIGIN:?STELE_BACKEND_ORIGIN is required (e.g. http://backend:8080 — scheme + host + port, no path)}"

export STELE_BACKEND_ORIGIN

envsubst '${STELE_BACKEND_ORIGIN}' < /etc/nginx/templates/default.conf.template \
  > /etc/nginx/conf.d/default.conf

mkdir -p /var/run
spawn-fcgi -s /var/run/fcgiwrap.socket -M 0666 -F 1 -- /usr/bin/fcgiwrap

exec nginx -g 'daemon off;'
