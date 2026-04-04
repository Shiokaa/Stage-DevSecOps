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

# Supprime l'utilisateur ubuntu au premier boot de chaque VM déployée.
sudo tee /etc/cloud/cloud.cfg.d/98-remove-template-user.cfg > /dev/null << 'EOF'
runcmd:
  - userdel -r ubuntu || true
  - rm -f /etc/sudoers.d/ubuntu
EOF

# Reset de cloud-init pour pouvoir le relancer sur les prochaines VMs déployées
sudo cloud-init clean --logs --seed --machine-id

# Enlève le machine-id pour que chaque VM déployée génère le sien propre
sudo truncate -s 0 /etc/machine-id
sudo rm -f /var/lib/dbus/machine-id
sudo ln -sf /etc/machine-id /var/lib/dbus/machine-id