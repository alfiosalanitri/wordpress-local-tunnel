FROM php:8.1-apache

RUN docker-php-ext-install mysqli

RUN docker-php-ext-enable mysqli

RUN a2enmod rewrite

RUN service apache2 restart

WORKDIR /app

COPY ./src/main.sh /app/data/scripts/web_main.sh

RUN chmod +x /app/data/scripts/web_main.sh

ENTRYPOINT ["/app/data/scripts/web_main.sh"]