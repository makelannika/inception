#!/bin/sh
set -e

# Wait for MariaDB to be ready
echo "Waiting for MariaDB..."
while ! nc -z $WORDPRESS_DB_HOST 3306; do
    sleep 1
done
echo "MariaDB is ready!"

# Check if WordPress config exists, create if it doesn't
if [ ! -f /var/www/html/wp-config.php ]; then
    echo "Creating wp-config.php..."
    cp /var/www/html/wp-config-sample.php /var/www/html/wp-config.php
    
    # Update the configuration with environment variables
    sed -i "s/database_name_here/$WORDPRESS_DB_NAME/" /var/www/html/wp-config.php
    sed -i "s/username_here/$WORDPRESS_DB_USER/" /var/www/html/wp-config.php
    sed -i "s/password_here/$WORDPRESS_DB_PASSWORD/" /var/www/html/wp-config.php
    sed -i "s/localhost/$WORDPRESS_DB_HOST/" /var/www/html/wp-config.php
    
    # Add unique authentication keys and salts
    SALT=$(curl -L https://api.wordpress.org/secret-key/1.1/salt/)
    # Convert line breaks in the curl response to sed-compatible format
    SALT=$(echo "$SALT" | sed -E ':a;N;$!ba;s/\r{0,1}\n/\\n/g')
    sed -i "/put your unique phrase here/c\\$SALT" /var/www/html/wp-config.php
fi

# Check if WordPress is already installed
wp core is-installed --path=/var/www/html --allow-root || {
    echo "Setting up WordPress..."
    
    # Install WordPress
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
}

# Start PHP-FPM
echo "Starting PHP-FPM..."
exec php-fpm -F