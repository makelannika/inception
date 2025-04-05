FROM	debian:11.11

#	tells apt-get not to prompt for user input during package installation
ENV	DEBIAN_FRONTEND=noninteractive

#	installs NGINX to serve WordPress,
#	openSSL toolkit for generating self-signed SSL certificates for HTTPS
#	and gettext-base package for envsubst command
RUN	apt-get update && apt-get install -y \
	nginx \
	openssl \
	gettext-base \
	&& rm -rf /var/lib/apt/lists/*

#	copies files from local build context into the container
COPY	/conf/nginx.conf /etc/nginx/nginx.conf

#	copy pre-generated SSL certificates
COPY	./ssl/ /etc/nginx/ssl/
RUN	chmod 777 /etc/nginx/ssl/

#COPY	/tools/docker-entrypoint.sh /usr/local/bin/
#RUN	chmod +x /usr/local/bin/docker-entrypoint.sh

EXPOSE	443

#	substitutes domain name in configuration file
#	runs NGINX - in the foreground with -g daemon off
#	ensuring docker will be able to stop container properly
#CMD	envsubst '$DOMAIN_NAME' < /etc/nginx/nginx.conf > /etc/nginx/nginx.conf && nginx -g 'daemon off;'
CMD	["nginx", "-g", "daemon off;"]
