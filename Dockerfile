FROM php:8.4-fpm AS prepare_php
LABEL description="Build php extensions for Cachet Docker Image"

RUN apt-get update && \
	apt-get upgrade -y && \
	apt-get install -y \
		libpq-dev \
		libpng-dev \
		libzip-dev \
		libicu-dev \
		libwebp-dev \
		libfreetype6-dev \
		libjpeg62-turbo-dev \
		zlib1g-dev && \
	docker-php-ext-install \
		pdo_pgsql \
		zip \
		pgsql \
		exif \
		gd \
		bcmath \
		intl \
		pcntl && \
	apt-get clean && \
	rm -rf /var/lib/apt/lists/*

# ============================================================================
FROM prepare_php AS build_webroot
LABEL description="Build Cachet webroot"

RUN apt-get update && \
	apt-get upgrade -y && \
	apt-get install -y \
		git && \
	apt-get clean && \
	rm -rf /var/lib/apt/lists/*

# Set Default User for Apache
USER www-data
WORKDIR /tmp/build

RUN git clone -b 3.x https://github.com/cachethq/cachet.git .

# Send in GITHUB_TOKEN to bypass github API ratelimits, note that I use ARG
# because railway.com does not support build secrets
ARG GITHUB_TOKEN

# Install composer into container
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Use GitHub token for Composer because of rate-limitter
RUN composer config github-oauth.github.com $GITHUB_TOKEN

# Install Composer dependencies and NPM packages
RUN composer install --no-dev -o

# RUN composer update cachethq/core
RUN composer update cachethq/core

# Ensure secret does not come over to final
RUN composer config --unset github-oauth.github.com

# Publish the Cachet assets
RUN php artisan vendor:publish --tag=cachet

# Create symbolic link between storage and public directory
RUN php artisan storage:link

# ============================================================================
FROM prepare_php
LABEL description="Serve Cachet using PHP 8.4-fpm"

COPY --link .docker/php/cachet.ini /usr/local/etc/php/conf.d/cachet.ini
COPY --link --from=build_webroot /tmp/build /var/www/html
