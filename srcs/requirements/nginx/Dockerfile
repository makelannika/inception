FROM alpine:3.20.6

# Install NGINX and OpenSSL
RUN apk update && apk add --no-cache \
    nginx \
    openssl \
    gettext

# Create SSL directory and ensure it exists
RUN mkdir -p /etc/nginx/ssl

# Copy NGINX configuration file
COPY conf/nginx.conf /etc/nginx/nginx.conf.template

# Copy SSL certificates
COPY ssl/ /etc/nginx/ssl/
RUN chmod 600 /etc/nginx/ssl/*

# Create directories for NGINX
RUN mkdir -p /var/www/html /run/nginx

# Copy entrypoint script
COPY tools/docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod +x /docker-entrypoint.sh

# Expose port for HTTPS
EXPOSE 443

# Start NGINX with environment variable substitution
ENTRYPOINT ["/docker-entrypoint.sh"]
