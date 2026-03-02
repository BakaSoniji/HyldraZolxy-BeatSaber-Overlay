# Build stage: compile TypeScript
FROM node:22-alpine AS build

WORKDIR /app
COPY package.json ./
RUN npm install && npm install typescript

COPY js/*.ts js/
# Create a minimal tsconfig since it's gitignored
RUN echo '{"compilerOptions":{"target":"ES2020","module":"ES2020","moduleResolution":"node","strict":true,"sourceMap":false},"include":["js/*.ts"]}' > tsconfig.json
RUN npx tsc

# Runtime stage: Apache + PHP
FROM php:8.3-apache

# Enable required Apache modules
RUN a2enmod headers expires

# Copy application files
COPY --from=build /app/js/*.js /var/www/html/js/
COPY js/libs/ /var/www/html/js/libs/
COPY php/ /var/www/html/php/
COPY skins/ /var/www/html/skins/
COPY fonts/ /var/www/html/fonts/
COPY pictures/ /var/www/html/pictures/
COPY index.html /var/www/html/
COPY .htaccess /var/www/html/
COPY *.css /var/www/html/

# Create cache directory for PHP with correct ownership
RUN mkdir -p /var/www/html/php/Cache && chown -R www-data:www-data /var/www/html/php/Cache

# Allow .htaccess overrides
RUN sed -i 's/AllowOverride None/AllowOverride All/g' /etc/apache2/sites-available/000-default.conf
RUN echo '<Directory /var/www/html>\n    AllowOverride All\n</Directory>' >> /etc/apache2/apache2.conf

EXPOSE 80
