#!/bin/sh

# Wait for MariaDB
while ! nc -z ${WORDPRESS_DB_HOST} 3306; do
    echo "Waiting for MariaDB..."
    sleep 3
done

# Download WordPress if not already present
if [ ! -f "/var/www/html/wp-config.php" ]; then
    # Download and extract WordPress
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

define('AUTH_KEY',         'unique phrase');
define('SECURE_AUTH_KEY',  'unique phrase');
define('LOGGED_IN_KEY',    'unique phrase');
define('NONCE_KEY',        'unique phrase');
define('AUTH_SALT',        'unique phrase');
define('SECURE_AUTH_SALT', 'unique phrase');
define('LOGGED_IN_SALT',   'unique phrase');
define('NONCE_SALT',       'unique phrase');

\$table_prefix = 'wp_';
define('WP_DEBUG', false);
if ( !defined('ABSPATH') )
    define('ABSPATH', dirname(__FILE__) . '/');
require_once(ABSPATH . 'wp-settings.php');
EOF

    # Create users (this would normally be done via web setup)
    # In a real implementation, you'd want to use wp-cli for this
    echo "WordPress files prepared. Complete the setup via web interface."
fi

# Fix permissions
chown -R www-data:www-data /var/www/html

# Start PHP-FPM
exec php-fpm -F