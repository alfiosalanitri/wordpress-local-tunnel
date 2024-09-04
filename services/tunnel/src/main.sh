#!/bin/sh
# Print message colors
readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly NC='\033[0m' # No Color
readonly DATA_DIR=/app/data
readonly READY_FILE="$DATA_DIR/tmp/tunnel_step_ready.txt"

# clear the ready file
if [ -f "$READY_FILE" ]; then
  rm $READY_FILE
fi

# Loop until the specified file is found, indicating the previous job is done
while [ ! -f $DATA_DIR/tmp/web_step_ready.txt ]; do
  echo "[+] Waiting for web job..."
  sleep 5
done

sleep 10

cloudflared tunnel --url http://web:80 2> $READY_FILE