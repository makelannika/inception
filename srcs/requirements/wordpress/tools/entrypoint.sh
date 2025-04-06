#!/bin/sh

# Install netcat if not already present
if ! command -v nc &> /dev/null; then
    apk add --no-cache netcat-openbsd
fi

# Wait for MariaDB
echo "Waiting for MariaDB..."
while ! nc -z ${WORDPRESS_DB_HOST} 3306; do
    echo "MariaDB is unavailable - sleeping"
    sleep 3
done
echo "MariaDB is up - continuing"

# Ensure the www-data user exists
if ! id "www-data" &>/dev/null; then
    adduser -u 82 -D -S -G www-data www-data
fi

# Wait a bit more to ensure MariaDB is fully initialized
sleep 5

# Download WordPress if not already present
if [ ! -f "/var/www/html/wp-config.php" ]; then
    echo "Setting up WordPress..."
    
    # Download WordPress core files
    curl -o wordpress.tar.gz https://wordpress.org/latest.tar.gz
    tar -xzf wordpress.tar.gz --strip-components=1
    rm wordpress.tar.gz
    
    # Create wp-config.php
    cat > wp-config.php << EOF
<?php
define('DB_NAME', '${WORDPRESS_DB_NAME}');
define('DB_USER', '${WORDPRESS_DB_USER}');
define('DB_PASSWORD', '${WORDPRESS_DB_PASSWORD}');
define('DB_HOST', '${WORDPRESS_DB_HOST}');
define('DB_CHARSET', 'utf8');
define('DB_COLLATE', '');

\$table_prefix = 'wp_';
define('WP_DEBUG', false);
if ( !defined('ABSPATH') )
    define('ABSPATH', dirname(__FILE__) . '/');
require_once(ABSPATH . 'wp-settings.php');
EOF
    
    echo "WordPress setup complete! Access via HTTPS to complete installation."
else
    echo "WordPress is already set up."
fi

# Fix permissions
chown -R www-data:www-data /var/www/html

# Start PHP-FPM
echo "Starting PHP-FPM..."
exec php-fpm -F