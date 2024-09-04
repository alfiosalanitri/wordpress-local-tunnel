FROM debian:latest

RUN  apt-get update \
  && apt-get install -y wget \
  && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY ./src/main.sh /app/data/scripts/generate_wp_config_preview.sh

RUN chmod +x /app/data/scripts/generate_wp_config_preview.sh

ENTRYPOINT ["/app/data/scripts/generate_wp_config_preview.sh"]