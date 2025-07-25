FROM ghcr.io/monkeysoftnl/docker-php:8.4-apache
LABEL description="Docker image for Laravel 10 with Apache, PHP 8.4, Composer, NPM, and Filament admin panel."
LABEL version="1.0"

# Set temporary to user root to copy files and set permissions
USER root

# Copy the application files to the Apache document root
RUN git clone -b 3.x https://github.com/cachethq/cachet.git /var/www/html

# Set the correct permissions for the application files
RUN chown -R www-data:www-data /var/www

# Set Default User for Apache
USER www-data

# Install Composer dependencies and NPM packages
RUN composer install --no-dev -o

# RUN composer update cachethq/core
RUN composer update cachethq/core

# Publish the Cachet assets
RUN php artisan vendor:publish --tag=cachet