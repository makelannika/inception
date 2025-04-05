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
    php82-phar \
    php82-gd \
    curl \
    unzip

# Create directories
RUN mkdir -p /var/www/html
RUN mkdir -p /run/php

# Set ownership for PHP-FPM
RUN adduser -u 82 -D -S -G www-data www-data
RUN chown -R www-data:www-data /var/www/html /run/php

# Configure PHP-FPM
COPY /conf/php-fpm.conf /etc/php82/php-fpm.conf
RUN ln -s /usr/sbin/php-fpm82 /usr/sbin/php-fpm

# Set working directory
WORKDIR /var/www/html

# Download and extract WordPress
RUN curl -o wordpress.tar.gz https://wordpress.org/latest.tar.gz \
    && tar -xzf wordpress.tar.gz --strip-components=1 \
    && rm wordpress.tar.gz

# Copy WordPress configuration
COPY --chown=www-data:www-data . /var/www/html
COPY /conf/wp-config.php /var/www/html/wp-config.php
RUN chown www-data:www-data /var/www/html/wp-config.php

# Expose port for PHP-FPM
EXPOSE 9000

# Start PHP-FPM
CMD ["php-fpm", "-F"]


# FROM	debian:11.11

# #	tells apt-get not to prompt for user input during package installation
# ENV	DEBIAN_FRONTEND=noninteractive

# # 	installs required dependencies for wordpress
# RUN	apt-get update && apt-get install -y \
# 	php7.4-fpm \
# 	php7.4-mysql \
# 	php7.4-curl \
# 	php7.4-gd \
# 	php7.4-mbstring \
# 	php7.4-xml \
# 	php7.4-zip \
# 	unzip \
# 	curl \
# 	&& rm -rf /var/lib/apt/lists/*

# RUN	mkdir -p /run/php && chown -R www-data:www-data /run/php

# #	creates /var/www/html directory
# RUN	mkdir -p /var/www/html

# #	changes working directory, commands after this point
# #	will be executed from /var/www/html  
# WORKDIR	/var/www/html

# #	downloads wordpress in a compressed archive format (.tar.gz)
# #	extracts the compressed files placing them into the current directory
# #	removes the archive after extraction to save space in the container
# RUN	curl -o wordpress.tar.gz https://wordpress.org/latest.tar.gz \
# 	&& tar -xzf wordpress.tar.gz --strip-components=1 \
# 	&& rm wordpress.tar.gz

# #	www-data is a system user commonly used by web servers
# # 	this gives NGINX access to the wordpress files as they
# #	are copied into /var/www/html
# COPY	--chown=www-data:www-data . /var/www/html

# COPY	/conf/wp-config.php /var/www/html/wp-config.php
# RUN	chown www-data:www-data /var/www/html/wp-config.php

# #	technically not needed since Docker’s internal networking allows NGINX
# #	to communicate with WordPress without explicitly exposing the port
# #	but good practice - informs Docker about intended usage
# EXPOSE	9000

# #	starts PHP-FPM - in the foreground with built-in -F command
# #	ensuring docker will be able to stop container properly
# CMD	["php-fpm7.4", "-F"]

