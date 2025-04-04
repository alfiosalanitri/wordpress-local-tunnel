#!/bin/bash
# Print message colors
readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly NC='\033[0m' # No Color
readonly DATA_DIR=/app/data
readonly READY_FILE="$DATA_DIR/tmp/web_step_ready.txt"

# clear the ready file
if [ -f "$READY_FILE" ]; then
  rm $READY_FILE
fi


# Loop until the specified file is found, indicating the previous job is done
while [ ! -f $DATA_DIR/tmp/generate_wp_config_preview_step_ready.txt ]; do
  echo "[+] Waiting for job [generate_wp_config_preview]..."
  sleep 5
done

sleep 10
# Override the original wp-config.php
echo -e "[+] coping wp-config.php to /var/www/html/wp-config.php..."
cp "$DATA_DIR/wp-config.php" /var/www/html/wp-config.php || { echo -e "${RED}[✘]${NC} wp-config.php copy failed!"; exit 1; }
echo -e "${GREEN}[✔]${NC} wp-config.php copied"
# Create a file to signal that the this step is ready
touch $READY_FILE
exec apache2-foreground
