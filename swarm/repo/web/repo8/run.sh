#!/usr/bin/env bash

# Start nginx to begin serving the mirror
echo "Starting webserver"
nginx -g 'daemon off;' &

# Run once to perform initial sync
if [ -z "$SKIP_INITIAL_SYNC" ]; then
    echo "Performing intial sync"
    /usr/bin/reposync -p /usr/share/nginx/html/centos8-x86_64 --download-metadata &> /var/log/reposync.log
fi

echo "Starting cron for subsequent syncs"
/usr/sbin/crond -n


# Wait for the webserver... forever
wait
