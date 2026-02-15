#!/bin/bash

# This script monitors the nginx.conf file and the conf.d directory for any changes.
# When a change is detected, it reloads the NGINX configuration inside the
# 'nginx-server' docker container.

# The paths to monitor
WATCH_PATHS="/home/pasindu/Projects/nginx_tut/nginx.conf /home/pasindu/Projects/nginx_tut/conf.d"

# The command to execute on change
RELOAD_COMMAND="docker exec nginx-server nginx -s reload"

# Check if inotifywait is installed
if ! command -v inotifywait &> /dev/null
then
    echo "inotifywait could not be found, please install inotify-tools"
    exit 1
fi

echo "Watching for changes in $WATCH_PATHS"

while true; do
  # Wait for any change in the specified paths
  inotifywait -r -e modify,create,delete,move $WATCH_PATHS
  
  # When a change is detected, execute the reload command
  echo "Detected a change, reloading NGINX configuration..."
  $RELOAD_COMMAND
done
