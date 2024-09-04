FROM debian:latest

RUN  apt-get update \
  && apt-get install -y wget \
  && rm -rf /var/lib/apt/lists/*

# install cloudflared
RUN wget -q https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64 && \
    chmod +x cloudflared-linux-amd64 && \
    mv cloudflared-linux-amd64 /usr/local/bin/cloudflared

WORKDIR /app

COPY ./src/main.sh /app/data/scripts/tunnel_main.sh

RUN chmod +x /app/data/scripts/tunnel_main.sh

ENTRYPOINT ["/bin/bash", "/app/data/scripts/tunnel_main.sh"]
