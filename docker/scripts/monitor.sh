#!/bin/bash
set -o pipefail

# All directories to monitor.
CONFIG_DIRS=(
    "/etc/nginx/conf.d"
    "/usr/local/openresty/nginx/lua"
    "/usr/local/openresty/nginx/conf"
)

# Delay in seconds to wait for more changes before reloading Nginx.
DELAY_IN_SECONDS=2

reload_nginx() {
    echo "$(date) - Changes detected, waiting for more changes..." >> /var/log/monitor.log
    sleep $DELAY_IN_SECONDS
    echo "$(date) - Delay passed, checking Nginx configuration..." >> /var/log/monitor.log
    if nginx -t 2>> /var/log/monitor-errors.log; then
        nginx -s reload
        echo "$(date) - Nginx successfully reloaded." >> /var/log/monitor.log
    else
        echo "$(date) - Nginx configuration test failed, reload skipped." >> /var/log/monitor-errors.log
    fi
}

# PID of the last reload task
last_pid=0

# Process inotify events.
inotifywait -m -r -e modify,create,delete "${CONFIG_DIRS[@]}" --format '%w%f' |
    while IFS= read -r file; do
        # Kill the last reload task if it's still running
        if [ $last_pid -ne 0 ]; then
            kill $last_pid 2>/dev/null
        fi
        # Start a new reload task in the background
        reload_nginx &
        last_pid=$!
    done