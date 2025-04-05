FROM alpine:3.20.6

# Install MariaDB
RUN apk update && apk add --no-cache \
    mariadb \
    mariadb-client

# Create directories and set permissions
RUN mkdir -p /var/lib/mysql && \
    chown -R mysql:mysql /var/lib/mysql && \
    mkdir -p /var/run/mysqld && \
    chown -R mysql:mysql /var/run/mysqld && \
    mkdir -p /docker-entrypoint-initdb.d

# Copy configuration file
COPY /conf/my.cnf /etc/my.cnf

# Copy initialization script
COPY /tools/create_users.sql /docker-entrypoint-initdb.d/
RUN chown mysql:mysql /docker-entrypoint-initdb.d/create_users.sql && \
    chmod 644 /docker-entrypoint-initdb.d/create_users.sql

# Create an initialization script
RUN echo '#!/bin/sh \n\
if [ ! -d "/var/lib/mysql/mysql" ]; then \n\
    mysql_install_db --user=mysql --datadir=/var/lib/mysql \n\
    mysqld --user=mysql --bootstrap < /docker-entrypoint-initdb.d/create_users.sql \n\
fi \n\
exec mysqld --user=mysql' > /entrypoint.sh && \
    chmod +x /entrypoint.sh

# Expose port for MariaDB
EXPOSE 3306

# Start MariaDB
CMD ["/entrypoint.sh"]

# FROM	debian:11.11

# #	tells apt-get not to prompt for user input during package installation
# ENV	DEBIAN_FRONTEND=noninteractive

# #	installs server and client for MariaDB
# RUN	apt-get update && apt-get install -y \
# 	mariadb-server \
# 	mariadb-client \
# 	&& rm -rf /var/lib/apt/lists/*

# #	ensures ownership of relevant files
# RUN	mkdir -p /var/lib/mysql && chown -R mysql:mysql /var/lib/mysql

# #	creates socket directory and sets permissions
# RUN	mkdir -p /var/run/mysqld && chown -R mysql:mysql /var/run/mysqld

# #	copies configuration file into the container
# COPY	/conf/my.cnf /etc/mysql/my.cnf

# #	scripts placed in /docker-entrypoint-initdb.d are executed automatically first time the container runs
# #	once the database has been initialized the script will not run again unless database is removed or reset
# COPY	/tools/create_users.sql /docker-entrypoint-initdb.d/
# RUN	chown mysql:mysql /docker-entrypoint-initdb.d/create_users.sql && chmod 644 /docker-entrypoint-initdb.d/create_users.sql

# EXPOSE	3306

# #	runs MariaDB - in the foreground by default
# CMD	["mysqld"]

