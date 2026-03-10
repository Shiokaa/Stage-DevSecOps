while [ ! -f /var/lib/cloud/instance/boot-finished ]; do echo 'En attente de cloud-init...'; sleep 1; done
sudo systemctl enable qemu-guest-agent
sudo systemctl start qemu-guest-agent
sudo cloud-init clean --logs
sudo rm -f /etc/cloud/cloud.cfg.d/subiquity-disable-cloudinit-networking.cfg
sudo rm -f /etc/netplan/00-installer-config.yaml
echo "Ubuntu 24.04 Template par packer - Date de création : $(date)" | sudo tee /etc/issue