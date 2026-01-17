#!/bin/sh

mkdir -p /run/mysqld
chown -R mysql:mysql /run/mysqld

if [ ! -d "/var/lib/mysql/mysql" ]; then
    
    chown -R mysql:mysql /var/lib/mysql

    # Initialize database
    mariadb-install-db --basedir=/usr --datadir=/var/lib/mysql --user=mysql > /dev/null

    # Create setup file
    tfile=`mktemp`
    if [ ! -f "$tfile" ]; then
        return 1
    fi

    cat << EOF > $tfile
USE mysql;
FLUSH PRIVILEGES;

DELETE FROM mysql.user WHERE User='';
DROP DATABASE IF EXISTS test;
DELETE FROM mysql.db WHERE Db='test' OR Db='test\\_%';

CREATE DATABASE IF NOT EXISTS $SQL_DATABASE CHARACTER SET utf8 COLLATE utf8_general_ci;
CREATE USER IF NOT EXISTS '$SQL_USER'@'%' IDENTIFIED BY '$SQL_PASSWORD';
GRANT ALL PRIVILEGES ON $SQL_DATABASE.* TO '$SQL_USER'@'%';

ALTER USER 'root'@'localhost' IDENTIFIED BY '$SQL_ROOT_PASSWORD';
FLUSH PRIVILEGES;
EOF

    # Run bootstrap
    /usr/bin/mariadbd --user=mysql --bootstrap < $tfile
    rm -f $tfile
    
    echo "Database initialized."
fi

exec /usr/bin/mariadbd --user=mysql --console
