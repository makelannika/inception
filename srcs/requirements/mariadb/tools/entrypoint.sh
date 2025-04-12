#!/bin/sh

if [ ! -d "/var/lib/mysql/mysql" ]; then
    echo "Initializing MariaDB data directory..."
    mysql_install_db --user=mysql --datadir=/var/lib/mysql

    echo "Starting MariaDB for initialization..."
    /usr/bin/mysqld --user=mysql --datadir=/var/lib/mysql --skip-networking &

    until mysqladmin ping -s; do
        echo "Waiting for MariaDB to be ready..."
        sleep 1
    done

    mysql -u root << EOF
CREATE DATABASE IF NOT EXISTS ${MYSQL_DATABASE};
CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
GRANT ALL PRIVILEGES ON ${MYSQL_DATABASE}.* TO '${MYSQL_USER}'@'%';
ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';
FLUSH PRIVILEGES;
EOF

    echo "Shutting down temporary MariaDB server..."
    mysqladmin -u root -p${MYSQL_ROOT_PASSWORD} shutdown

    echo "Database initialized with proper permissions."
fi

echo "Starting MariaDB server..."
exec /usr/bin/mysqld --user=mysql --console
