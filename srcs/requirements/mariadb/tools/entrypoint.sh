#!/bin/sh

# Initialize the database if it doesn't exist
if [ ! -d "/var/lib/mysql/mysql" ]; then
    echo "Initializing MariaDB database..."
    mysql_install_db --user=mysql --datadir=/var/lib/mysql
    
    echo "Creating initial database and users..."
    # Start MariaDB in bootstrap mode to execute initial SQL
    mysqld --user=mysql --bootstrap < /docker-entrypoint-initdb.d/create_users.sql
    
    echo "Database initialization complete."
fi

# Start MariaDB server
echo "Starting MariaDB server..."
exec mysqld --user=mysql