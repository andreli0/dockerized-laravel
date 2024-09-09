
#Use php 8.1.2
FROM php:8.1.2-fpm

SHELL ["/bin/bash", "-c"]
# Install common php extension dependencies
RUN apt-get update && apt-get install -y \
    libfreetype-dev \
    libjpeg62-turbo-dev \
    libpng-dev \
    libpq-dev \
    zlib1g-dev \
    libzip-dev \
    npm \
    unzip \
    curl \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) gd \
    && docker-php-ext-install zip \
    && docker-php-ext-install pdo_pgsql \
    && curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.3/install.sh | bash


# Set the working directory
COPY . /var/www/app
WORKDIR /var/www/app

#RUN chown -R www-data:www-data /var/www/app \
#    && chmod -R 775 /var/www/app/storage



    # install composer
COPY --from=composer:2.6.5 /usr/bin/composer /usr/local/bin/composer

# copy composer.json to workdir & install dependencies
COPY composer.json ./
RUN composer install

COPY package.json ./

RUN npm install 

RUN source ~/.bashrc \
    && nvm install 22.6 \
    && nvm use v22.6.0 \
    && npm run build

# Set correct permissions for the storage and bootstrap/cache directories
RUN chown -R www-data:www-data /var/www/app/storage /var/www/app/bootstrap/cache \
    && chown -R root:root /var/www/app/storage /var/www/app/bootstrap/cache \
    && chmod -R 777 /var/www/app/storage /var/www/app/bootstrap/cache 

COPY wait-for-it.sh ./
RUN chmod +x wait-for-it.sh
