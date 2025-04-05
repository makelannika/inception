#!/bin/sh
set -e

# Wait for MariaDB to be ready
echo "Waiting for MariaDB..."
while ! nc -z $WORDPRESS_DB_HOST 3306; do
    sleep 1
done
echo "MariaDB is ready!"

# Check if WordPress is already installed
if [ ! -f /var/www/html/wp-config.php ]; then
    echo "Setting up WordPress..."
    
    # Copy the wp-config.php file
    cp /tmp/wp-config.php /var/www/html/wp-config.php
    chown www-data:www-data /var/www/html/wp-config.php
    
    # Install WordPress if not already installed
    wp core install --path=/var/www/html \
        --url=https://$DOMAIN_NAME \
        --title="WordPress Site" \
        --admin_user=amakela \
        --admin_password=pswd123 \
        --admin_email=amakela@example.com \
        --skip-email \
        --allow-root
        
    # Create a second user (editor)
    wp user create another-user user@example.com \
        --role=editor \
        --user_pass=pswd321 \
        --path=/var/www/html \
        --allow-root
        
    echo "WordPress setup complete!"
else
    echo "WordPress already set up!"
fi

# Start PHP-FPM
echo "Starting PHP-FPM..."
exec php-fpm -F