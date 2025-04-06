FROM alpine:3.20.6

# Install NGINX and OpenSSL
RUN apk update && apk add --no-cache nginx openssl

# Create SSL directory
RUN mkdir -p /etc/nginx/ssl

# Generate self-signed certificate
RUN openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -keyout /etc/nginx/ssl/privkey.key \
    -out /etc/nginx/ssl/certificate.crt \
    -subj "/CN=amakela.42.fr"

# Copy NGINX configuration
COPY conf/nginx.conf /etc/nginx/nginx.conf

# Create necessary directories
RUN mkdir -p /var/www/html /run/nginx

EXPOSE 443

# Start NGINX
CMD ["nginx", "-g", "daemon off;"]