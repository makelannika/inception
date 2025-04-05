#!/bin/sh
set -e

# Wait for MariaDB to be ready with a better check
echo "Waiting for MariaDB..."
maxcounter=45

counter=1
while ! mysql -h $WORDPRESS_DB_HOST -u $WORDPRESS_DB_USER -p$WORDPRESS_DB_PASSWORD -e "SHOW DATABASES;" > /dev/null 2>&1; do
    sleep 1
    counter=`expr $counter + 1`
    if [ $counter -gt $maxcounter ]; then
        echo "We have been waiting for MariaDB too long already; failing."
        exit 1
    fi;
    echo "Still waiting for MariaDB... ($counter/$maxcounter)"
done
echo "MariaDB is ready!"

-- Switch to WordPress database
USE wordpress;

# Change to the proper directory
cd /var/www/html

# Check if WordPress is already installed
if ! wp core is-installed --allow-root; then
    echo "Setting up WordPress..."
    
    # Generate random salts for security
    wp config shuffle-salts --allow-root
    
    # Install WordPress if not already installed
    wp core install --allow-root \
        --url=https://$DOMAIN_NAME \
        --title="WordPress Site" \
        --admin_user=amakela \
        --admin_password=pswd123 \
        --admin_email=amakela@example.com \
        --skip-email
        
    # Create a second user (editor)
    wp user create another-user user@example.com \
        --role=editor \
        --user_pass=pswd321 \
        --allow-root
        
    echo "WordPress setup complete!"
else
    echo "WordPress already set up!"
fi

# Change ownership of files to www-data for security
chown -R www-data:www-data /var/www/html

# Start PHP-FPM
echo "Starting PHP-FPM..."
exec php-fpm -F