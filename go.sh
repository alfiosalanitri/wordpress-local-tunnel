#!/bin/bash

# Load .env
source .env

# Function to restore the backup and stop Docker
restore() {
    echo "[*] Restoring backup and stopping Docker..."
    cp "$WORDPRESS_INSTALL_DIR/wp-config.php.bkp" "$WORDPRESS_INSTALL_DIR/wp-config.php"
    rm -f "$WORDPRESS_INSTALL_DIR/wp-config.php.bkp"
    docker compose down
    docker rmi -f $(docker images -q --filter "reference=$COMPOSE_PROJECT_NAME*") 2>/dev/null
    docker system prune -f
    echo "[✔] Restore complete."
}

case "$1" in
  "")
    # Create the backup of wp-config.php file
    cp "$WORDPRESS_INSTALL_DIR/wp-config.php" "$WORDPRESS_INSTALL_DIR/wp-config.php.bkp"
    # Start Docker
    docker compose up -d --build

    # Timeout in seconds (3 minutes = 180 seconds)
    TIMEOUT=180
    ELAPSED=0
    INTERVAL=5

    # Loop until the specified file is found or timeout occurs
    while [ ! -f data/tmp/tunnel_step_ready.txt ]; do
        if [ "$ELAPSED" -ge "$TIMEOUT" ]; then
            echo "[✖] Timeout reached. Tunnel job did not complete within 3 minutes."
            restore
            exit 1
        fi
        echo "[+] Waiting for tunnel job..."
        sleep "$INTERVAL"
        ELAPSED=$((ELAPSED + INTERVAL))
    done
    echo "[+] Waiting 30 sec for tunnel job..."
    sleep 30
    cloudflare_random_url=$(grep -oE 'https://[^ ]+trycloudflare\.com\b' data/tmp/tunnel_step_ready.txt)
    echo -e "${GREEN}[✔]${NC} Here we go! Visit: $cloudflare_random_url"
    ;;
  "--stop" | "-s")
    # Call restore function
    restore
    ;;
  *)
    echo "Use '--stop' or '-s' to stop and clear or blank to start."
    exit 1
    ;;
esac
