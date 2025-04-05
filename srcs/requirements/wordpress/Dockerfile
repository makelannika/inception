FROM alpine:3.20.6

# Install dependencies
RUN apk update && apk add --no-cache \
    php82 \
    php82-fpm \
    php82-mysqli \
    php82-ctype \
    php82-curl \
    php82-dom \
    php82-exif \
    php82-fileinfo \
    php82-mbstring \
    php82-openssl \
    php82-xml \
    php82-zip \
    php82-gd \
    php82-phar \
    php82-json \
    php82-tokenizer \
    php82-simplexml \
    curl \
    wget \
    mariadb-client \
    netcat-openbsd

# Install WP-CLI
RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
&& chmod +x wp-cli.phar \
&& mv wp-cli.phar /usr/local/bin/wp

# Create directories
RUN mkdir -p /var/www/html
RUN mkdir -p /run/php

# Set ownership for PHP-FPM
RUN adduser -u 82 -D -S -G www-data www-data
RUN chown -R www-data:www-data /var/www/html /run/php

# Configure PHP-FPM - Fix path and ensure clean file
COPY conf/php-fpm.conf /etc/php82/php-fpm.conf
RUN ln -s /usr/sbin/php-fpm82 /usr/sbin/php-fpm

# Set working directory
WORKDIR /var/www/html

# Download and extract WordPress
RUN curl -o wordpress.tar.gz https://wordpress.org/latest.tar.gz \
    && tar -xzf wordpress.tar.gz --strip-components=1 \
    && rm wordpress.tar.gz

# Copy WordPress configuration
COPY conf/wp-config.php /var/www/html/wp-config.php
RUN chown www-data:www-data /var/www/html/wp-config.php

COPY tools/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Expose port for PHP-FPM
EXPOSE 9000

# Start PHP-FPM
CMD ["php-fpm", "-F"]