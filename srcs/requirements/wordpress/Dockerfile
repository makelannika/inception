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
    curl \
    mariadb-client

# Create necessary directories
RUN mkdir -p /var/www/html /run/php
RUN ln -sf /usr/bin/php82 /usr/bin/php

# Configure PHP-FPM
COPY conf/php-fpm.conf /etc/php82/php-fpm.conf
RUN ln -s /usr/sbin/php-fpm82 /usr/sbin/php-fpm

# Copy entrypoint script
COPY tools/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

WORKDIR /var/www/html

EXPOSE 9000

ENTRYPOINT ["/entrypoint.sh"]