FROM php:8.1-apache

RUN apt-get update \
  && apt-get install -y \
  tar \
  default-mysql-client \
  && docker-php-ext-install mysqli pdo pdo_mysql \
  && docker-php-ext-enable mysqli pdo pdo_mysql

WORKDIR /app

COPY ./src/srdb-script.tar /app/data/lib/srdb-script.tar

COPY ./src/main.sh /app/data/scripts/srdb_replace_main.sh

RUN chmod +x /app/data/scripts/srdb_replace_main.sh

ENTRYPOINT ["/app/data/scripts/srdb_replace_main.sh"]