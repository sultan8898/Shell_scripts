#!/bin/bash

# Get the current working directory dynamically
BASE_DIR=$(pwd)

# Initialize an empty list for apps without Redis
MISSING_REDIS_APPS=()

# Loop through all directories inside the base directory
for APP in $(ls "$BASE_DIR"); do
  # Define the path to the public_html directory
  APP_DIR="$BASE_DIR/$APP/public_html"

  if [ -d "$APP_DIR" ]; then
    cd "$APP_DIR" || continue

    # Run the Redis info command
    echo "Checking Redis for application: $APP"
    if wp redis info --allow-root &>/dev/null; then
      echo "Redis is running for $APP"
    else
      echo "Redis is NOT running for $APP"
      MISSING_REDIS_APPS+=("$APP")
    fi
  else
    echo "Directory does not exist for application: $APP"
  fi
done

# List applications without Redis
echo "Applications without Redis:"
for APP in "${MISSING_REDIS_APPS[@]}"; do
  echo "$APP"
done
