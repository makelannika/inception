FROM alpine:3.20.6

# Install NGINX and OpenSSL
RUN apk update && apk add --no-cache \
    nginx \
    openssl \
    gettext

# Create SSL directory and ensure it exists
RUN mkdir -p /etc/nginx/ssl

# Copy NGINX configuration file
COPY /conf/nginx.conf /etc/nginx/nginx.conf

# Copy SSL certificates - removing the .dockerignore restriction
COPY ./ssl/ /etc/nginx/ssl/
RUN chmod 600 /etc/nginx/ssl/*

# Create directories for NGINX
RUN mkdir -p /var/www/html /run/nginx

# Expose port for HTTPS
EXPOSE 443

# Start NGINX
CMD ["nginx", "-g", "daemon off;"]
