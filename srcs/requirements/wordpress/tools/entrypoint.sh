#!/bin/sh

# Initial delay to ensure MariaDB has fully initialized
sleep 5

# Then proceed with the connection check, but with the improved check method
echo "Checking if MariaDB is up..."
while ! mysql -h${WP_DB_HOST} -u${WP_DB_USER} -p${WP_DB_PASSWORD} -e "SELECT 1" >/dev/null 2>&1; do
    echo "Waiting for MariaDB..."
    sleep 3
done

echo "MariaDB ready"

# Check if WordPress is already configured
if [ ! -f "/var/www/html/wp-config.php" ]; then

    # Create wp-config.php
    wp config create --allow-root \
        --dbname="${WP_DB_NAME}" \
        --dbuser="${WP_DB_USER}" \
        --dbpass="${WP_DB_PASSWORD}" \
        --dbhost="${WP_DB_HOST}" \
	--dbcharset="utf8" \
	--dbcollate="" \
        --path="/var/www/html"
    
    # Install WordPress silently - no installation screen
    wp core install --allow-root \
        --url="${DOMAIN_NAME}" \
        --title="WordPress Site" \
        --admin_user="${WP_ADMIN_USER}" \
        --admin_password="${WP_ADMIN_PASSWORD}" \
        --admin_email="${WP_ADMIN_EMAIL}" \
        --skip-email
    
    # Create an additional user
    wp user create --allow-root \
        "${WP_USER}" \
        "${WP_USER_EMAIL}" \
        --user_pass="${WP_USER_PASSWORD}" \
        --role=author
    
    echo "WordPress installation complete!"
else
    echo "WordPress already configured."
fi

# Ensure correct permissions
chown -R nobody:nobody /var/www/html

# Start PHP-FPM
echo "Starting PHP-FPM..."
exec php-fpm82 -F
