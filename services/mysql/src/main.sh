#!/bin/bash

# Print message colors
readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly NC='\033[0m' # No Color
readonly DATA_DIR='/app/data'
readonly READY_FILE="$DATA_DIR/tmp/mysql_step_ready.txt"

# Clear the ready file if it exists
if [ -f "$READY_FILE" ]; then
  rm "$READY_FILE"
fi

# Loop until the specified file is found, indicating the previous job is done
while [ ! -f "$DATA_DIR/tmp/database_dump_step_ready.txt" ]; do
  echo "[+] Waiting for job [database_dump]..."
  sleep 5
done

# Import the database
if [ ! -f "$DATA_DIR/dump.sql" ]; then
    echo -e "${RED}[x]${NC} Error: Database dump not found at $DATA_DIR/dump.sql."  
    exit 1    
fi

cp "$DATA_DIR/dump.sql" /docker-entrypoint-initdb.d/

# Start the MySQL server in the background
echo "[+] Starting MySQL server..."
nohup docker-entrypoint.sh mysqld > /var/log/mysql.log 2>&1 &
MYSQL_PID=$!

# Create a file to signal that the MySQL step is ready
touch "$READY_FILE"

# Keep the container running
wait "$MYSQL_PID"