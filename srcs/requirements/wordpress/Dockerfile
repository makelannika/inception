FROM alpine:3.20.6

# Install dependencies
RUN apk update && apk add --no-cache \
    php82 \
    php82-fpm \
    php82-mysqli \
    php82-json \
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
    php82-tokenizer \
    php82-simplexml \
    curl \
    mariadb-client \
    netcat-openbsd

# Install WP-CLI
RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
    && chmod +x wp-cli.phar \
    && mv wp-cli.phar /usr/local/bin/wp

# Create symlink for PHP
RUN ln -sf /usr/bin/php82 /usr/bin/php

# Create necessary directories
RUN mkdir -p /var/www/html /run/php

# Make sure we have the www-data user
RUN adduser -u 82 -D -S -G www-data www-data || echo "User already exists"

# Configure PHP-FPM
COPY conf/php-fpm.conf /etc/php82/php-fpm.conf
RUN ln -s /usr/sbin/php-fpm82 /usr/sbin/php-fpm

# Copy entrypoint script
COPY tools/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

WORKDIR /var/www/html

EXPOSE 9000

ENTRYPOINT ["/entrypoint.sh"]