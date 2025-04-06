#!/bin/sh

# Check if database is already initialized
if [ ! -d "/var/lib/mysql/mysql" ]; then
    echo "Initializing MariaDB data directory..."
    
    # Initialize MySQL data directory
    mysql_install_db --user=mysql --datadir=/var/lib/mysql
    
    # Start MariaDB in the background temporarily
    /usr/bin/mysqld --user=mysql --datadir=/var/lib/mysql --skip-networking &
    
    # Wait for MariaDB to start
    pid="$!"
    for i in $(seq 1 30); do
        if mysqladmin ping &>/dev/null; then
            break
        fi
        echo "Waiting for MariaDB to start... ($i/30)"
        sleep 1
    done
    
    if [ "$i" = 30 ]; then
        echo "MariaDB startup failed!"
        exit 1
    fi
    
    # Configure MariaDB
    mysql -u root << EOF
CREATE DATABASE IF NOT EXISTS ${MYSQL_DATABASE};
CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
GRANT ALL PRIVILEGES ON ${MYSQL_DATABASE}.* TO '${MYSQL_USER}'@'%';
ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';
FLUSH PRIVILEGES;
EOF
    
    # Stop the background MariaDB
    if ! mysqladmin -u root -p${MYSQL_ROOT_PASSWORD} shutdown; then
        kill "$pid"
        wait "$pid"
    fi
    
    echo "Database initialized"
else
    echo "MariaDB data directory already exists."
fi

# Ensure proper permissions
chown -R mysql:mysql /var/lib/mysql

# Start MariaDB
echo "Starting MariaDB server..."
exec /usr/bin/mysqld --user=mysql --console