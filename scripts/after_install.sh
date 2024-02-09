#!/bin/bash
set -e  # Exit on error

WEB_ROOT="/var/www/html"
REPO_URL="https://git-codecommit.ap-south-1.amazonaws.com/v1/repos/datayaan_website2.0"
REPO_NAME="datayaan_website2.0"

# Change permissions (adjust as needed)
sudo chmod -R 755 $WEB_ROOT

# Clone repository directly into the web root
git clone $REPO_URL $WEB_ROOT

# Remove unnecessary files and directories
rm -rf $WEB_ROOT/$REPO_NAME
rm -f $WEB_ROOT/index.nginx-debian.html

echo "Deployment successful."
