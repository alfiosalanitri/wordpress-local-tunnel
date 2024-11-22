#!/bin/bash

# Load .env
source .env

case "$1" in
  "")
    # Create the backup of wp-config.php file
    cp "$WORDPRESS_INSTALL_DIR/wp-config.php" "$WORDPRESS_INSTALL_DIR/wp-config.php.bkp"
    # Start Docker
    docker compose up -d --build

    # Loop until the specified file is found, indicating the tunnel job is done
    while [ ! -f data/tmp/tunnel_step_ready.txt ]; do
        echo "[+] Waiting for tunnel job..."
        sleep 5
    done
    sleep 5
    cloudflare_random_url=$(grep -oE 'https://[^ ]+trycloudflare\.com\b' data/tmp/tunnel_step_ready.txt)
    echo -e "${GREEN}[✔]${NC} Here we go! Visit: $cloudflare_random_url"
    ;;
  "--stop" | "-s")
    # Restore the backup
    cp "$WORDPRESS_INSTALL_DIR/wp-config.php.bkp" "$WORDPRESS_INSTALL_DIR/wp-config.php"
    rm "$WORDPRESS_INSTALL_DIR/wp-config.php.bkp"
    # Stop Docker
    docker compose down
    # Clear docker images
    docker rmi -f $(docker images -q --filter "reference=$COMPOSE_PROJECT_NAME*")
    docker system prune -f
    ;;
  *)
    echo "Use '--stop' or '-s' to stop and clear or blank to start."
    exit 1
    ;;
esac
