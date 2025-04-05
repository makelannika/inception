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
COPY conf/my.cnf /etc/my.cnf

# Copy entrypoint script
COPY tools/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Expose port for MariaDB
EXPOSE 3306

# Start MariaDB
ENTRYPOINT ["/entrypoint.sh"]