FROM alpine:3.20.6

# Install NGINX and OpenSSL
RUN apk update && apk add --no-cache \
    nginx \
    openssl \
    gettext

# Create SSL directory
RUN mkdir -p /etc/nginx/ssl

# Generate SSL certificates
RUN openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -keyout /etc/nginx/ssl/privkey.key \
    -out /etc/nginx/ssl/certificate.crt \
    -subj "/C=FR/ST=IDF/L=Paris/O=42/OU=42/CN=amakela.42.fr"

# Copy NGINX configuration file
COPY conf/nginx.conf /etc/nginx/nginx.conf

# Create directories for NGINX
RUN mkdir -p /var/www/html /run/nginx

# Expose port for HTTPS
EXPOSE 443

# Start NGINX
CMD ["nginx", "-g", "daemon off;"]