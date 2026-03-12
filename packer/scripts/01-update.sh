#!/bin/bash
set -euo pipefail

echo ">>> Updating system packages..."
sudo apt-get update -y
sudo apt-get upgrade -y
sudo apt-get dist-upgrade -y
