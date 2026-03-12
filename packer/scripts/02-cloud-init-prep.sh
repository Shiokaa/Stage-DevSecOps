#!/bin/bash
set -euo pipefail

echo ">>> Preparing cloud-init for template re-use..."

# Supprime les fichiers de configuration laissés par l'autoinstall (subiquity).
# Ces fichiers écrasent les paramètres cloud-init de Proxmox/Terraform (ciuser, sshkeys, etc.)
sudo rm -f /etc/cloud/cloud.cfg.d/99-installer.cfg
sudo rm -f /etc/cloud/cloud.cfg.d/subiquity-disable-cloudinit-networking.cfg
sudo rm -f /etc/cloud/cloud.cfg.d/50-curtin-networking.cfg

# Configure cloud-init pour utiliser le datasource NoCloud (utilisé par Proxmox)
sudo tee /etc/cloud/cloud.cfg.d/99-proxmox.cfg > /dev/null << 'EOF'
datasource_list: [NoCloud, ConfigDrive, None]
EOF

# Reset de cloud-init pour pouvoir le run sur les prochaines machines
sudo cloud-init clean --logs --seed --machine-id

# Enlève le machine-id pour que chaque machine ait le sien
sudo truncate -s 0 /etc/machine-id
sudo rm -f /var/lib/dbus/machine-id
sudo ln -sf /etc/machine-id /var/lib/dbus/machine-id
