#!/bin/bash

# This script checks if the import directory contains a valid .sql file and imports it; otherwise,
# it automatically exports the database of the local WordPress installation.

# Print message colors
readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly NC='\033[0m' # No Color

readonly DATA_DIR=/app/data
readonly READY_FILE="$DATA_DIR/tmp/database_dump_step_ready.txt"
readonly DUMP_FILE_TO_IMPORT=$(find "/app/import/" -type f -name "*.sql" | head -n 1)

# clear the ready file
if [ -f "$READY_FILE" ]; then
  rm $READY_FILE
fi

# check if wp-config.php file exists and create a dump.sql from current WordPress installation
export_database_from_wordpress_installation() {
  local WP_CONFIG_FILE="/app/wp-config.php"
  # Check wp-config.php file
  if [ ! -f "$WP_CONFIG_FILE" ]; then
      echo -e "${RED}[x]${NC} Error: The WordPress configuration file '$WP_CONFIG_FILE' does not exist."
      exit 1
  fi

  echo -e "[+] Exporting WordPress database ..."
  local DB_NAME=$(cat $WP_CONFIG_FILE | grep DB_NAME | cut -d \' -f 4)
  local DB_USER=$(cat $WP_CONFIG_FILE | grep DB_USER | cut -d \' -f 4)
  local DB_PASSWORD=$(cat $WP_CONFIG_FILE | grep DB_PASSWORD | cut -d \' -f 4)
  local DB_HOST=$WORDPRESS_MYSQL_HOST
  local DB_PORT=$WORDPRESS_MYSQL_PORT

  # Check if current mysql host is alive
  local mysql_ready=$(mysqladmin ping -h $DB_HOST -P $DB_PORT -u$DB_USER -p$DB_PASSWORD --silent 2>/dev/null)
  if [ "$mysql_ready" != "mysqld is alive" ]; then
    echo -e "${RED}[x]${NC} Error: mysql connection failed on host $DB_HOST and port $DB_PORT"
    exit 1
  fi

  mysqldump -u$DB_USER -p$DB_PASSWORD -h $DB_HOST -P $DB_PORT $DB_DUMP_ARGS $DB_NAME > "$DATA_DIR/dump.sql"
  if ! grep -qE 'CREATE TABLE|INSERT INTO|ALTER TABLE|DROP TABLE' "$DATA_DIR/dump.sql"; then
    echo -e "${RED}[x]${NC} Error: mysqldump failed."
    exit 1
  fi
  echo -e "${GREEN}[✔]${NC} Database saved to $DATA_DIR/dump.sql"
  touch $READY_FILE
}


# Check if custom dump file exists into data/import
if [[ ! -f "$DUMP_FILE_TO_IMPORT" ]]; then
  echo -e "[!] No dump file to import found"
  export_database_from_wordpress_installation
  exit 0
fi

# Check if the file is empty
if [[ ! -s "$DUMP_FILE_TO_IMPORT" ]]; then
  echo -e "[!] The dump file to import is empty"
  export_database_from_wordpress_installation
  exit 0
fi

# Check if the file contains basic SQL commands
if ! grep -qE 'CREATE TABLE|INSERT INTO|ALTER TABLE|DROP TABLE' "$DUMP_FILE_TO_IMPORT"; then
  echo -e "[!] The dump file to import isn't valid"
  export_database_from_wordpress_installation
  exit 0
fi

echo -e "${GREEN}[✔]${NC} $DUMP_FILE_TO_IMPORT file copied to $DATA_DIR/dump.sql"
cp $DUMP_FILE_TO_IMPORT "$DATA_DIR/dump.sql"
touch $READY_FILE