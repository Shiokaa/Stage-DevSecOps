#!/bin/bash
set -euo pipefail

echo ">>> Cleaning up for smaller template..."

# Clean apt cache
sudo apt-get autoremove -y
sudo apt-get clean -y

# Clear logs
sudo truncate -s 0 /var/log/**/*.log 2>/dev/null || true
sudo truncate -s 0 /var/log/syslog 2>/dev/null || true
sudo truncate -s 0 /var/log/auth.log 2>/dev/null || true

# Clear temp
sudo rm -rf /tmp/* /var/tmp/*

# Clear shell history
history -c
cat /dev/null > ~/.bash_history

echo ">>> Cleanup complete."
