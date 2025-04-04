#!/bin/bash

# Print message colors
readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly NC='\033[0m' # No Color

readonly DATA_DIR="/app/data"
readonly READY_FILE="$DATA_DIR/tmp/generate_wp_config_preview_step_ready.txt"
readonly WP_CONFIG_SAMPLE_FILE="$DATA_DIR/wp-config-sample.php"
readonly WP_CONFIG_FILE_PREVIEW="$DATA_DIR/wp-config.php"

# clear the ready file
if [ -f "$READY_FILE" ]; then
  rm $READY_FILE
fi

# Loop until the specified file is found, indicating the previous job is done
while [ ! -f $DATA_DIR/tmp/mysql_step_ready.txt ]; do
  echo "[+] Waiting for job [mysql_dump]..."
  sleep 5
done


# this function get the table_prefix from dump.sql file
get_wp_table_prefix() {
  local file="$1"

  # Search for the pattern in the file and extract the prefix
  local prefix=$(grep -o '[^`]\+_commentmeta' "$file" | head -n 1 | awk -F'_commentmeta' '{print $1 "_"}')
  if [[ -n "$prefix" ]]; then
      echo $prefix
      exit 0
  else
      echo -e "${RED}[x]${NC} Error: This isn't a valid WordPress dump file."
      exit 1
  fi
}

# Create the file wp-config-preview from the original one
echo -e "[+] Copying $WP_CONFIG_SAMPLE_FILE file into data/wp-config.php ..."
cp $WP_CONFIG_SAMPLE_FILE $WP_CONFIG_FILE_PREVIEW
# Change the host in the new wp-config-preview file
sed -i "s/define( 'DB_HOST', '.*' );/define( 'DB_HOST', 'mysql' );/" "$WP_CONFIG_FILE_PREVIEW"
# Change the db name in the new wp-config-preview file
sed -i "s/define( 'DB_NAME', '.*' );/define( 'DB_NAME', '$MYSQL_DOCKER_DATABASE' );/" "$WP_CONFIG_FILE_PREVIEW"
# Change the user in the new wp-config-preview file
sed -i "s/define( 'DB_USER', '.*' );/define( 'DB_USER', '$MYSQL_DOCKER_ROOT_USER' );/" "$WP_CONFIG_FILE_PREVIEW"
# Change the password in the new wp-config-preview file
sed -i "s/define( 'DB_PASSWORD', '.*' );/define( 'DB_PASSWORD', '$MYSQL_DOCKER_ROOT_PASSWORD' );/" "$WP_CONFIG_FILE_PREVIEW"
# Setup debug
sed -i "s/define( 'WP_DEBUG', false );/define( 'WP_DEBUG', $WORDPRESS_DEBUG );/" "$WP_CONFIG_FILE_PREVIEW"
sed -i "s/define( 'WP_DEBUG_DISPLAY', false );/define( 'WP_DEBUG_DISPLAY', $WORDPRESS_DEBUG_DISPLAY );/" "$WP_CONFIG_FILE_PREVIEW"
sed -i "s/define( 'WP_DEBUG_LOG', false );/define( 'WP_DEBUG_LOG', $WORDPRESS_DEBUG_LOG );/" "$WP_CONFIG_FILE_PREVIEW"

table_prefix=$(get_wp_table_prefix "$DATA_DIR/dump.sql")
# Change the table_prefix in the new wp-config-preview file
sed -i "s/table_prefix = 'wp_';/table_prefix = '$table_prefix';/" "$WP_CONFIG_FILE_PREVIEW"

# Fix that prevents infinite loop during site loading
insert_line="# Prevents infinite loop redirect\n\$_SERVER['HTTPS'] = 'on';"
# Use sed to insert the line immediately after <?php
sed -i "s|<?php|<?php\n$insert_line|" "$WP_CONFIG_FILE_PREVIEW"
echo -e "${GREEN}[✔]${NC} wp-config.php file generated"
# Create a file to signal that the this step is ready
touch $READY_FILE