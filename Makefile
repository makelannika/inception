DOCKER_COMPOSE = srcs/docker-compose.yml
VOLUMES = /home/amakela/data

all: setup build up

setup:
	@mkdir -p $(VOLUMES)/mariadb
	@mkdir -p $(VOLUMES)/wordpress
	@echo "✅ Directories created for persistent storage"

build:
	@docker-compose -f $(DOCKER_COMPOSE) build
	@echo "✅ Docker images built"

up:
	@docker-compose -f $(DOCKER_COMPOSE) up -d
	@echo "✅ Containers started"

mariadb:
	@docker-compose -f $(DOCKER_COMPOSE) up -d --build mariadb
	@echo "✅ MariaDB built"

wordpress:
	@docker-compose -f $(DOCKER_COMPOSE) up -d --build wordpress
	@echo "✅ WordPress built"

nginx:
	@docker-compose -f $(DOCKER_COMPOSE) up -d --build nginx
	@echo "✅ NGINX built"

stop:
	@docker-compose -f $(DOCKER_COMPOSE) stop
	@echo "✅ Containers stopped"

down:
	@docker-compose -f $(DOCKER_COMPOSE) down
	@echo "✅ Containers stopped and removed"

clean: down
	@docker system prune -af
	@docker volume prune -f
	@echo "✅ Cleaned up all Docker resources"

fclean: clean
	@rm -rf $(VOLUMES)/mariadb $(VOLUMES)/wordpress
	@echo "✅ Full cleanup done"

re: fclean all
	@echo "✅ Full cleanup and restart"
