#!/bin/sh

echo "MariaDB container starting..."

# Ensure directories exist with proper permissions
mkdir -p /var/lib/mysql /run/mysqld
chown -R mysql:mysql /var/lib/mysql /run/mysqld
chmod 777 /run/mysqld

# Initialize DB if needed
if [ ! -d "/var/lib/mysql/mysql" ]; then
    echo "Initializing MariaDB data directory..."
    mysql_install_db --user=mysql --datadir=/var/lib/mysql
fi

# Start MariaDB temporarily for setup
echo "Starting MariaDB for initialization..."
/usr/bin/mysqld --user=mysql --datadir=/var/lib/mysql --skip-networking &
pid="$!"

# Wait for MariaDB server to start
until mysqladmin ping -s 2>/dev/null; do
    echo "Waiting for MariaDB to be ready..."
    sleep 1
done
echo "MariaDB started for initialization"

# Run setup commands
mysql -u root << EOF
-- In case this is a restart, drop and recreate the user to ensure correct permissions
DROP USER IF EXISTS '${MYSQL_USER}'@'localhost';
DROP USER IF EXISTS '${MYSQL_USER}'@'%';

-- Create database if it doesn't exist
CREATE DATABASE IF NOT EXISTS ${MYSQL_DATABASE};

-- Create user with proper access from any host (%)
CREATE USER '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
GRANT ALL PRIVILEGES ON ${MYSQL_DATABASE}.* TO '${MYSQL_USER}'@'%';

-- Set root password and permissions
ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';
FLUSH PRIVILEGES;
EOF

# Shutdown temporary server
echo "Shutting down temporary MariaDB server..."
mysqladmin -u root -p${MYSQL_ROOT_PASSWORD} shutdown
wait "$pid"

echo "Database initialized with proper permissions."

# Start the actual MariaDB server
echo "Starting MariaDB server..."
exec /usr/bin/mysqld --user=mysql --console