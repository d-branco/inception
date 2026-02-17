#!/bin/sh

if [ ! -f "/etc/nginx/ssl/inception.crt" ] || [ ! -f "/etc/nginx/ssl/inception.key" ]; then
    mkdir -p /etc/nginx/ssl
    openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
        -keyout /etc/nginx/ssl/inception.key \
        -out /etc/nginx/ssl/inception.crt \
        -subj "/C=PT/ST=Porto/L=Porto/O=42/OU=42Porto/CN=${DOMAIN_NAME}"
    echo "SSL certificates generated."
fi

exec nginx -g "daemon off;"
