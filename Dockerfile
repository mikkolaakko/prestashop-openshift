FROM php:7.4.33-apache

# Enabling module rewrite
RUN a2enmod rewrite

# Install php extensions and dependencies
ADD https://github.com/mlocati/docker-php-extension-installer/releases/latest/download/install-php-extensions /usr/local/bin/

RUN chmod +x /usr/local/bin/install-php-extensions && \
    install-php-extensions gd pdo_mysql intl zip opcache mysqli && \
	docker-php-ext-enable gd pdo_mysql intl zip opcache mysqli
    
RUN apt-get update && apt-get install -y \
 	libzip-dev \
	zip

# Install system requirements checker
# ADD phppsinfo.php /var/www/html/

# Download PrestaShop
RUN curl -LJO https://github.com/PrestaShop/PrestaShop/releases/download/1.7.8.8/prestashop_1.7.8.8.zip && \
	unzip prestashop_1.7.8.8.zip && \
	rm -f prestashop_1.7.8.8.zip && \
	unzip -o prestashop.zip && \
	rm -f prestashop.zip

# https://devdocs.prestashop-project.org/1.7/basics/installation/install-from-cli/
RUN php install/index_cli.php --domain localhost \
    --domain=prestashop.apps.sandbox-m2.ll9k.p1.openshiftapps.com \
	--name=PrestaShop \
    --db_server=mysql \
    --db_name=prestashop \
    --db_user=prestashop \
    --db_password=prestashop \
	--firstname=John \
	--lastname=Doe \
	--password=<ADMIN_PASSWORD> \
	--email=john.doe@example.com \
    --newsletter=0 \
    --send_email=0

RUN rm -rf install && mv admin admin4883u0iim

# Use the development configuration
# RUN mv "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini"

# Accept connections on port 8080
RUN sed -i "s/Listen 80/Listen 8080/" /etc/apache2/ports.conf
EXPOSE 8080

# Sets the directory and file permissions
RUN chgrp -R 0 /var/cache /var/www/html && \
    chmod -R g+rwX /var/cache /var/www/html

# COPY ./docker-entrypoint.sh /
# ENTRYPOINT ["/docker-entrypoint.sh"]