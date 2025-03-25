FROM	debian:11.11

#	installs server and client for MariaDB
RUN	apt-get update && apt-get install -y \
	mariadb-server \
	mariadb-client \
	&& rm -rf /var/lib/apt/lists/*

#	ensures ownership of relevant files
RUN	chown -R mysql:mysql /var/lib/mysql /etc/mysql

#	copies configuration file into the container
COPY	./requirements/mariadb/conf/my.cnf /etc/mysql/my.cnf

EXPOSE	3306

#	runs MariaDB - in the foreground by default
CMD	["mysqld"]

