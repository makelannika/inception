#!/bin/sh

echo "WordPress container starting..."

# Wait for MariaDB to be ready
echo "Waiting for MariaDB..."
while ! nc -z ${WORDPRESS_DB_HOST} 3306; do
    echo "Waiting for MariaDB..."
    sleep 3
done
echo "MariaDB is up! Waiting a bit more for initialization..."
sleep 5  # Give MariaDB a bit more time to initialize fully

# Download WordPress if not already present
if [ ! -f "/var/www/html/index.php" ]; then
    echo "WordPress not found, downloading..."
    curl -o wordpress.tar.gz https://wordpress.org/latest.tar.gz
    tar -xzf wordpress.tar.gz --strip-components=1
    rm wordpress.tar.gz
    
    # Create wp-config.php
    echo "Creating wp-config.php..."
    cat > wp-config.php << EOF
<?php
define('DB_NAME', '${WORDPRESS_DB_NAME}');
define('DB_USER', '${WORDPRESS_DB_USER}');
define('DB_PASSWORD', '${WORDPRESS_DB_PASSWORD}');
define('DB_HOST', '${WORDPRESS_DB_HOST}:3306');
define('DB_CHARSET', 'utf8');
define('DB_COLLATE', '');

\$table_prefix = 'wp_';
define('WP_DEBUG', false);
if ( !defined('ABSPATH') )
    define('ABSPATH', dirname(__FILE__) . '/');
require_once(ABSPATH . 'wp-settings.php');
EOF
    echo "WordPress files prepared."
fi

# Check if WordPress is already installed
if ! wp core is-installed --allow-root; then
    echo "Installing WordPress..."
    
    # Install WordPress
    wp core install \
        --allow-root \
        --url=https://${DOMAIN_NAME} \
        --title="WordPress Site" \
        --admin_user=amakela \
        --admin_password=amakela123 \
        --admin_email=amakela@example.com \
        --skip-email
    
    # Create a second non-admin user (requirement from the project)
    wp user create editor editor@example.com \
        --allow-root \
        --role=editor \
        --user_pass=editor123
    
    echo "WordPress installed successfully!"
else
    echo "WordPress already installed."
fi

# Fix permissions
echo "Setting correct file permissions..."
chown -R www-data:www-data /var/www/html

echo "Starting PHP-FPM..."
exec php-fpm -F