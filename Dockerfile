# syntax=docker/dockerfile:1

FROM composer:2 AS vendor
WORKDIR /var/www
COPY composer.json composer.lock ./
RUN composer install \
    --no-dev \
    --no-interaction \
    --prefer-dist \
    --optimize-autoloader \
    --no-scripts

FROM node:25-alpine AS frontend
WORKDIR /var/www
COPY package*.json vite.config.js ./
RUN npm ci
COPY resources ./resources
RUN npm run build

FROM dunglas/frankenphp:php8.4 AS base
RUN install-php-extensions \
    pdo_mysql \
    mbstring \
    exif \
    bcmath \
    gd \
    pcntl
WORKDIR /var/www

FROM base AS dev
RUN apt-get update && apt-get install -y nodejs npm
RUN npm install -g chokidar

FROM base AS production
COPY . .
COPY --from=vendor /var/www/vendor ./vendor
COPY --from=frontend /var/www/public/build ./public/build
RUN mkdir -p /var/www/storage /var/www/bootstrap/cache && \
    chown -R www-data:www-data /var/www/storage /var/www/bootstrap/cache

EXPOSE 8080
CMD ["sh", "-c", "php artisan octane:start --server=frankenphp --host=0.0.0.0 --port=${PORT:-8080}"]
