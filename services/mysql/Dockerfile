FROM mysql:8.0

WORKDIR /app

COPY ./src/main.sh /app/data/scripts/mysql_main.sh

RUN chmod +x /app/data/scripts/mysql_main.sh

ENTRYPOINT ["/app/data/scripts/mysql_main.sh"]