#!/bin/sh

# Wait for MariaDB
echo "Waiting for MariaDB..."
while ! mariadb -h mariadb -u $SQL_USER -p$SQL_PASSWORD -e "SELECT 1;" > /dev/null 2>&1; do
    sleep 1
done
echo "MariaDB is ready!"

if [ ! -f "wp-config.php" ]; then
    echo "Configuring WordPress..."
    
    # Download
    php -d memory_limit=512M /usr/local/bin/wp core download --allow-root

    # Config
    php -d memory_limit=512M /usr/local/bin/wp config create \
        --dbname=$SQL_DATABASE \
        --dbuser=$SQL_USER \
        --dbpass=$SQL_PASSWORD \
        --dbhost=mariadb \
        --allow-root

    # Install
    php -d memory_limit=512M /usr/local/bin/wp core install \
        --url=$DOMAIN_NAME \
        --title="$WP_TITLE" \
        --admin_user=$WP_ADMIN_USER \
        --admin_password=$WP_ADMIN_PASSWORD \
        --admin_email=$WP_ADMIN_EMAIL \
        --skip-email \
        --allow-root

    # Create User
    php -d memory_limit=512M /usr/local/bin/wp user create \
        $WP_USER \
        $WP_USER_EMAIL \
        --user_pass=$WP_PASSWORD \
        --role=author \
        --allow-root

    chown -R www-data:www-data /var/www/html
fi

echo "Starting PHP-FPM..."
exec /usr/sbin/php-fpm83 -F
