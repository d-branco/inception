#!/bin/sh

set -e

if [ ! -f "wp-settings.php" ]; then
    echo "Downloading WordPress..."
    curl -O https://wordpress.org/latest.tar.gz
    tar -xzvf latest.tar.gz --strip-components=1
    rm latest.tar.gz
    chown -R www-data:www-data /var/www/html
fi

echo "Starting PHP-FPM..."
exec /usr/sbin/php-fpm83 -F
