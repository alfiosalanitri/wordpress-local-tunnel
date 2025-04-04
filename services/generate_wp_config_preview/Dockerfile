FROM alpine:latest

RUN apk add --no-cache wget bash

WORKDIR /app

COPY ./src/main.sh /app/data/scripts/generate_wp_config_preview.sh

RUN chmod +x /app/data/scripts/generate_wp_config_preview.sh

ENTRYPOINT ["/bin/bash", "/app/data/scripts/generate_wp_config_preview.sh"]