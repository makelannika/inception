FROM	debian:11.11

#	tells apt-get not to prompt for user input during package installation
ENV	DEBIAN_FRONTEND=noninteractive

# 	installs required dependencies for wordpress
RUN	apt-get update && apt-get install -y \
	php-fpm \
	php-mysql \
	php-curl \
	php-gd \
	php-mbstring \
	php-xml \
	php-xmlrpc \
	php-soap \
	php-intl \
	php-zip \
	mariadb-client \
	wget \
	unzip \
	curl \
	&& apt-get clean \
	&& rm -rf /var/lib/apt/lists/*

#	changes working directory, commands after this point
#	will be executed from /var/www/html 
WORKDIR	/var/www/html

#	downloads wordpress in a compressed archive format (.tar.gz)
#	extracts the compressed files placing them into the current directory
#	removes the archive after extraction to save space in the container
RUN	curl -o wordpress.tar.gz https://wordpress.org/latest.tar.gz \
	&& tar -xzf wordpress.tar.gz --strip-components=1 \
	&& rm wordpress.tar.gz

#	www-data is a system user commonly used by web servers
# 	this gives NGINX access to the wordpress files that
#	are located in /var/www/html
RUN	chown -R www-data:www-data /var/www/html

#	technically not needed since Docker’s internal networking allows NGINX
#	to communicate with WordPress without explicitly exposing the port
#	but good practice - informs Docker about intended usage
EXPOSE	9000

#	starts PHP-FPM - in the foreground with built-in -F command
#	ensuring docker will be able to stop container properly
CMD	["php-fpm7.3", "-F"]

