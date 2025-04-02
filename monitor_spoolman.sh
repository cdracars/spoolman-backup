#!/bin/bash

CONFIG_DIR="."
BACKUP_SCRIPT="backup_spoolman.sh"

while true; do
  inotifywait -r -e modify,create,delete,move "$CONFIG_DIR"
  # Wait a bit for all file operations to complete
  sleep 10
  # Run backup script
  $BACKUP_SCRIPT
done
