FROM php:7.4-apache

RUN apt-get update && apt-get install -y curl \
      zip \
      apt-utils \ 
      unzip 
COPY 000-default.conf /etc/apache2/sites-available/000-default.conf
COPY start-apache /usr/local/bin

RUN docker-php-ext-install mysqli && \
    docker-php-ext-install pdo_mysql

#RUN echo "ServerName localhost" >> /etc/apache2/apache2.conf &&\
 #   a2enmod rewrite &&\
  #  service apache2 restart


# Copy composer.lock and composer.json
COPY composer.json /var/www/

# Copy application source
COPY . /var/www/
RUN chown -R www-data:www-data /var/www


RUN echo "ServerName localhost" >> /etc/apache2/apache2.conf &&\
    a2enmod rewrite &&\
    service apache2 restart


#Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
WORKDIR /var/www/
RUN composer install

CMD ["start-apache"]
