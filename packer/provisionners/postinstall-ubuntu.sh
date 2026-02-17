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
 
sudo bash -c "echo 'uninitialized' > /etc/machine-id"
if [ -f /var/lib/dbus/machine-id ]; then
    sudo rm /var/lib/dbus/machine-id
fi
 
sudo cat /dev/null > ~/.bash_history && history -c
history -w
 
sudo journalctl --rotate
sudo journalctl --vacuum-time=1s
 
sudo sed -i 's|nocloud-net;seedfrom=http://.*/||' /etc/default/grub
sudo sed -i 's/autoinstall//g' /etc/default/grub
sudo update-grub
sudo rm -f /etc/netplan/00-installer-config.yaml
 
echo "datasource_list: [ConfigDrive, NoCloud]" | sudo tee -a /etc/cloud/cloud.cfg.d/99-pve.cfg
sudo rm -f /etc/cloud/cloud.cfg.d/subiquity-disable-cloudinit-networking.cfg
sudo cloud-init clean --logs