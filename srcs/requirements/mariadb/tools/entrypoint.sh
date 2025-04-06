#!/bin/sh

echo "MariaDB container starting..."

# Always ensure directories exist with proper permissions
mkdir -p /var/lib/mysql /run/mysqld
chown -R mysql:mysql /var/lib/mysql /run/mysqld
chmod 777 /run/mysqld

# Initialize database directory if it doesn't exist
if [ ! -d "/var/lib/mysql/mysql" ]; then
    echo "Initializing MariaDB data directory..."
    mysql_install_db --user=mysql --datadir=/var/lib/mysql
fi

# Start MariaDB in the background to configure it
echo "Starting MariaDB for initialization..."
/usr/bin/mysqld --user=mysql --bootstrap << EOF
-- Create the database
CREATE DATABASE IF NOT EXISTS ${MYSQL_DATABASE};

-- Create WordPress user with correct host % (not localhost)
CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
GRANT ALL PRIVILEGES ON ${MYSQL_DATABASE}.* TO '${MYSQL_USER}'@'%';

-- Change root password
ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';

-- Make sure changes take effect
FLUSH PRIVILEGES;
EOF

echo "Database initialized/updated"

# Ensure proper permissions
chown -R mysql:mysql /var/lib/mysql

echo "Starting MariaDB server..."
exec /usr/bin/mysqld --user=mysql