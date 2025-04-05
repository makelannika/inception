FROM alpine:3.20.6

# Install NGINX and OpenSSL
RUN apk update && apk add --no-cache \
    nginx \
    openssl \
    gettext

# Create SSL directory and ensure it exists
RUN mkdir -p /etc/nginx/ssl
RUN openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -keyout /etc/nginx/ssl/nginx.key \
    -out /etc/nginx/ssl/nginx.crt \
    -subj "/C=FR/ST=IDF/L=Paris/O=42/OU=42/CN=AMAKELA.42.fr" 

# Copy NGINX configuration file
COPY conf/nginx.conf /etc/nginx/nginx.conf.template

# Create directories for NGINX
RUN mkdir -p /var/www/html /run/nginx

# Expose port for HTTPS
EXPOSE 443

# Start NGINX with environment variable substitution
CMD ["nginx", "-g", "daemon off;"]
