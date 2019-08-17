FROM		php:7.3.8-apache

MAINTAINER	drake

#Install dependencies
RUN	apt-get update && \
	apt-get install -y \
	git \
	libpq-dev \
	zlib1g-dev \
	libzip-dev

#Download composer
RUN	curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

#Install PHP extensions
RUN	docker-php-ext-install \
	bcmath \
	pdo_pgsql \
	pdo_mysql \
	zip

#Copy our sources to the corresponding folder
COPY	.			/var/www/laravel-app
COPY	.docker/vhost.conf	/etc/apache2/sites-available/000-default.conf

#Switch to the source folder
WORKDIR	/var/www/laravel-app

#Install Laravel dependencies and vendors
RUN	composer install

#Make sure that we have access to everything
RUN	chown -R www-data:www-data /var/www/laravel-app

#Enable rewrite
RUN	a2enmod rewrite

#Restart apache
RUN	service apache2 restart
