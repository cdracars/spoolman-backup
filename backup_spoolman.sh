#!/bin/bash

# Path to your Spoolman Docker configuration
DOCKER_CONFIG_DIR="."

# Path to store database backups
BACKUP_DIR="backups"
mkdir -p "$BACKUP_DIR"

# Timestamp for backup files
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")

# Back up Docker configuration
cd "$DOCKER_CONFIG_DIR"
if [ -d .git ]; then
  # Git is already initialized
  if git status --porcelain | grep .; then
    # There are changes, commit them
    git add .
    git commit -m "Automatic Spoolman Docker config backup $TIMESTAMP"
    echo "Spoolman Docker config changes committed on $TIMESTAMP"
  else
    echo "No Spoolman Docker config changes detected on $TIMESTAMP"
  fi
else
  # Initialize git repository
  git init
  git add .
  git commit -m "Initial commit of Spoolman Docker config"
  echo "Initialized git repository for Spoolman Docker config"
fi

# Back up the database from the Docker container
# Assuming your container is named 'spoolman' and uses SQLite
docker exec 4e086c712402 sqlite3 /app/data/spoolman.db .dump > "$BACKUP_DIR/spoolman_db_$TIMESTAMP.sql"

# If it's a MySQL/MariaDB database instead, use:
# docker exec spoolman_db mysqldump -u username -p password spoolman > "$BACKUP_DIR/spoolman_db_$TIMESTAMP.sql"

# Keep only the 10 most recent database backups
ls -t "$BACKUP_DIR"/spoolman_db_*.sql | tail -n +11 | xargs rm -f

echo "Spoolman database backed up to $BACKUP_DIR/spoolman_db_$TIMESTAMP.sql"
