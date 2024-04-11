#!/bin/bash
set -euxo pipefail

# Make the sure the `lua_logging.lua` log directory exists and the default log file is created.
mkdir -p /var/log/lua
touch /var/log/lua/default.log

# Ensure that NGINX has a writable PID file and runtime directory.
mkdir -p /var/run/nginx
touch /var/run/nginx.pid
chmod 0666 /var/run/nginx.pid

# Run the monitor script in the background to test the config changes and reload NGINX.
/usr/local/bin/monitor.sh &

exec "$@"
