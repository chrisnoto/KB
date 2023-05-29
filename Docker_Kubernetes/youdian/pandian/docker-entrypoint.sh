#!/usr/bin/env sh
set -eu

envsubst '${DOMAIN}' < /var/www/youdian_v107/Application/Admin/Conf/config.php.template >/var/www/youdian_v107/Application/Admin/Conf/config.php
envsubst '${DOMAIN}' < /etc/httpd/conf.d/pandian.conf.template > /etc/httpd/conf.d/pandian.conf

exec "$@"
