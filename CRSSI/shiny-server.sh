#!/bin/bash
set -e  # Exit on any error

mkdir -p /var/log/shiny-server || {
    echo "Failed to create directory"
    exit 1
}

if id shiny >/dev/null 2>&1; then
    chown shiny:shiny /var/log/shiny-server
else
    echo "Warning: shiny user doesn't exist, skipping chown"
fi

# Verify directory exists
if [ ! -d "/var/log/shiny-server" ]; then
    echo "ERROR: Directory /var/log/shiny-server was not created"
    exit 1
fi

echo "Directory created successfully:"
ls -la /var/log/ | grep shiny-server

exec shiny-server >> /var/log/shiny-server.log 2>&1
