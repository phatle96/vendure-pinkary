# Use an official PHP runtime as a parent image
FROM php:8.3-fpm

# Install system dependencies
RUN apt-get update && apt-get install -y \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    imagemagick \
    libmagickwand-dev \
    libzip-dev \
    zip \
    unzip \
    git \
    curl \
    libonig-dev \
    libxml2-dev \
    sqlite3 \
    libsqlite3-dev \
    && mkdir -p /usr/src/php/ext/imagick \
    && curl -fsSL https://github.com/Imagick/imagick/archive/7088edc353f53c4bc644573a79cdcd67a726ae16.tar.gz | tar xvz -C "/usr/src/php/ext/imagick" --strip 1 \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install imagick gd mbstring pdo pdo_mysql pdo_sqlite intl zip

# Install Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Set working directory
WORKDIR /var/www

# Copy the application code to the container
COPY . .

# Install dependencies
RUN composer install --optimize-autoloader --no-dev

# Expose the container port
EXPOSE 9000

# Start PHP-FPM
CMD ["php-fpm"]