#!/bin/sh

# Initialize DB if not already done
if [ ! -d "/var/lib/mysql/mysql" ]; then
    # Initialize MariaDB data directory
    mysql_install_db --user=mysql --datadir=/var/lib/mysql

    # Start MariaDB temporarily
    /usr/bin/mysqld --user=mysql --bootstrap << EOF
CREATE DATABASE IF NOT EXISTS ${MYSQL_DATABASE};
CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
GRANT ALL PRIVILEGES ON ${MYSQL_DATABASE}.* TO '${MYSQL_USER}'@'%';
ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';
FLUSH PRIVILEGES;
EOF
    echo "Database initialized"
fi

# Ensure proper permissions
chown -R mysql:mysql /var/lib/mysql

# Start MariaDB
exec /usr/bin/mysqld --user=mysql