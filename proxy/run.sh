#!/bin/sh

# if one command broke all file is broken
set -e

# environment substitute (fource put engine access)
envsubst < /etc/nginx/default.conf.tpl > /etc/nginx/conf.d/default.conf
# fix the configuration that define here (allow nginx run in a background)
nginx -g 'daemon off;'