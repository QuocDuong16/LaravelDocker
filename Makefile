# Makefile for Laravel Docker environment

# Docker command
DOCKER = docker

# Docker Compose command
DOCKER_COMPOSE = docker-compose

# Laravel Docker service name
LARAVEL_SERVICE = laravel_app

# MySQL Docker service name
MYSQL_SERVICE = mysql_db

# phpMyAdmin Docker service name
PHPMYADMIN_SERVICE = phpmyadmin

# Setup
setup: build start composer-update

# Build Laravel application
build:
	$(DOCKER_COMPOSE) build --no-cache --force-rm

# Start Laravel application
start:
	$(DOCKER_COMPOSE) up -d

# Stop Laravel application
stop:
	$(DOCKER_COMPOSE) stop

# Restart Laravel application
restart: stop start

# Connect to Laravel application container bash
bash:
	$(DOCKER_COMPOSE) exec $(LARAVEL_SERVICE) bash

# Run composer install
composer-install:
	$(DOCKER) exec $(LARAVEL_SERVICE) bash -c composer install

# Run composer update
composer-update:
	$(DOCKER) exec $(LARAVEL_SERVICE) bash -c composer update

# Run data
data:
	$(DOCKER) exec $(LARAVEL_SERVICE) bash -c "php artisan migrate"
	$(DOCKER) exec $(LARAVEL_SERVICE) bash -c "php artisan db:seed"

# Connect to MySQL database
mysql:
	$(DOCKER_COMPOSE) exec $(MYSQL_SERVICE) mysql -u root -p

# Connect to phpMyAdmin
phpmyadmin:
	$(DOCKER_COMPOSE) exec $(PHPMYADMIN_SERVICE) bash

# Create new Laravel project
create-project:
	$(DOCKER_COMPOSE) exec $(LARAVEL_SERVICE) composer create-project --prefer-dist laravel/laravel .
	$(DOCKER_COMPOSE) exec $(LARAVEL_SERVICE) chown -R www-data:www-data /var/www/html/storage /var/www/html/bootstrap/cache
