#!/bin/bash
set -e

echo "=== Début du nettoyage pour la création du template ==="

# 1. Nettoyer l'état de cloud-init (TRÈS IMPORTANT)
# Cela force cloud-init à se relancer intégralement au prochain boot
sudo cloud-init clean --logs --seed

# 2. Vider le machine-id (TRÈS IMPORTANT)
# Si toutes les VM ont le même machine-id, elles obtiendront la même IP du serveur DHCP
# et cloud-init pensera que c'est la même machine.
sudo truncate -s 0 /etc/machine-id
sudo rm -f /var/lib/dbus/machine-id
sudo ln -s /etc/machine-id /var/lib/dbus/machine-id

# 3. Supprimer les configurations réseau figées par l'installeur de l'ISO
# Si vous ne supprimez pas ça, Terraform n'arrivera pas à appliquer sa propre config IP
sudo rm -f /etc/netplan/00-installer-config.yaml
sudo rm -f /etc/netplan/50-cloud-init.yaml

# 4. Supprimer les clés SSH hôtes pour obliger leur recréation au premier boot
# (pour ne pas avoir de conflit de clés SSH entre vos différentes VM)
sudo rm -f /etc/ssh/ssh_host_*

# 5. Nettoyage des logs et du cache apt pour gagner de la place
sudo apt-get autoremove -y
sudo apt-get clean
sudo rm -rf /var/lib/apt/lists/*
sudo rm -rf /var/log/installer
sudo rm -rf /var/crash/*

# 6. Vider l'historique bash
cat /dev/null > ~/.bash_history
history -c

echo "=== Nettoyage terminé ==="
# Surtout ne pas faire de "reboot" ici. Laissez Packer éteindre la VM proprement.