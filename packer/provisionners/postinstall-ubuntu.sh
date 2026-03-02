#!/bin/bash
 
sudo service rsyslog stop
 
if [ -f /var/log/wtmp ]; then
    sudo truncate -s0 /var/log/wtmp
fi
if [ -f /var/log/lastlog ]; then
    sudo truncate -s0 /var/log/lastlog
fi
 
sudo rm -rf /tmp/*
sudo rm -rf /var/tmp/*
 
sudo truncate -s 0 /etc/machine-id
if [ -f /var/lib/dbus/machine-id ]; then
    sudo rm /var/lib/dbus/machine-id
fi
 
sudo cat /dev/null > ~/.bash_history && history -c
history -w
 
sudo journalctl --rotate
sudo journalctl --vacuum-time=1s
 
# Remove autoinstall and ds=nocloud from all grub config locations
sudo sed -i 's| ds=nocloud[^ "]*||g' /etc/default/grub
sudo sed -i 's/ autoinstall//g' /etc/default/grub

# Also clean grub.d overrides written by subiquity
if [ -d /etc/default/grub.d ]; then
    sudo sed -i 's| ds=nocloud[^ "]*||g' /etc/default/grub.d/*.cfg 2>/dev/null || true
    sudo sed -i 's/ autoinstall//g' /etc/default/grub.d/*.cfg 2>/dev/null || true
fi

sudo update-grub
sudo rm -f /etc/netplan/00-installer-config.yaml

# 1) First, run cloud-init clean BEFORE removing configs
#    (cloud-init clean can trigger dpkg hooks that recreate 90_dpkg.cfg)
sudo cloud-init clean --logs

# 2) NOW remove all installer/subiquity cloud-init configs that disable cloud-init
sudo rm -f /etc/cloud/cloud.cfg.d/subiquity-disable-cloudinit-networking.cfg
sudo rm -f /etc/cloud/cloud.cfg.d/99-installer.cfg
sudo rm -f /etc/cloud/cloud.cfg.d/90_dpkg.cfg
sudo rm -f /etc/cloud/cloud.cfg.d/curtin-preserve-sources.cfg

# Also remove the cloud-init.disabled marker if present
sudo rm -f /etc/cloud/cloud-init.disabled

# 3) Write a clean datasource config LAST (so nothing overwrites it)
echo "datasource_list: [ConfigDrive, NoCloud]" | sudo tee /etc/cloud/cloud.cfg.d/99-pve.cfg

# 4) Force ds-identify to always enable cloud-init
#    Without this, cloud-init-generator runs ds-identify which doesn't detect
#    the Proxmox cloud-init CD-ROM early enough and disables cloud-init.
echo "policy: enabled" | sudo tee /etc/cloud/ds-identify.cfg

# 5) Truncate machine-id to empty (cloud-init needs empty, not "uninitialized")
sudo truncate -s 0 /etc/machine-id

# 5) Verify 90_dpkg.cfg is really gone (debug output during packer build)
echo "--- cloud.cfg.d contents after cleanup ---"
ls -la /etc/cloud/cloud.cfg.d/
cat /etc/cloud/cloud.cfg.d/99-pve.cfg