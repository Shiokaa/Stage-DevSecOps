#!/bin/bash
set -euo pipefail

echo ">>> Preparing cloud-init for template re-use..."

# Écrase le default_user du distro Ubuntu pour que cloud-init
# utilise le "user:" fourni par le datasource Proxmox (ciuser).
sudo tee /etc/cloud/cloud.cfg.d/99-pve.cfg > /dev/null <<'EOF'
system_info:
  default_user:
    name: admin
    lock_passwd: true
    gecos: Cloud User
    groups: [adm, cdrom, dip, lxd, sudo]
    sudo: ["ALL=(ALL) NOPASSWD:ALL"]
    shell: /bin/bash
EOF

# Reset de cloud-init pour pouvoir le run sur les prochaines machines
sudo cloud-init clean --logs

# Enlève le machine-id pour que chaque machine est le sien
sudo truncate -s 0 /etc/machine-id
sudo rm -f /var/lib/dbus/machine-id
sudo ln -s /etc/machine-id /var/lib/dbus/machine-id
