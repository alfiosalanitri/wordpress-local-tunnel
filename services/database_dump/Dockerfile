FROM mysql:8.0

WORKDIR /app

COPY ./src/main.sh /app/data/scripts/database_dump_main.sh

RUN chmod +x /app/data/scripts/database_dump_main.sh

ENTRYPOINT ["/app/data/scripts/database_dump_main.sh"]