FROM php:8.4-fpm

# Install system dependencies
RUN apt-get update && apt-get install -y \
    git \
    curl \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    zip \
    unzip \
    libzip-dev \
    libicu-dev \
    mariadb-client \
    && rm -rf /var/lib/apt/lists/*

# Install PHP extensions
RUN docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd zip intl

# Install Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Set working directory
WORKDIR /app

# Copy application files
COPY . /app

# Install PHP dependencies
RUN composer install --no-interaction --optimize-autoloader

# Install Node dependencies and build assets
RUN apt-get update && apt-get install -y nodejs npm && rm -rf /var/lib/apt/lists/*
RUN npm install && npm run build

# Set permissions
RUN chown -R www-data:www-data /app/storage /app/bootstrap/cache
RUN chmod -R 775 /app/storage /app/bootstrap/cache
RUN mkdir -p /app/storage/logs && chmod -R 777 /app/storage/logs


EXPOSE 9000

CMD ["php-fpm"]