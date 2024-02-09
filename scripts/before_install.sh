#!/bin/bash
set -e  # Exit on error

# Update package information and install Nginx
apt-get update
apt-get install -y nginx

# Enable and start Nginx
systemctl enable nginx
systemctl start nginx

# Additional error handling if needed
if systemctl is-active --quiet nginx; then
  echo "Nginx started successfully."
else
  echo "Error: Nginx failed to start."
  exit 1
fi
