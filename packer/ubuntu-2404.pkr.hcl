# ──────────────────────────────────────────────
# Packer Build — Ubuntu 24.04 Template for Proxmox
# ──────────────────────────────────────────────
# Cela créer une VM avec :
#   - Ubuntu 24.04 installé automatiquement via cloud-init
#   - Réinitialisation de cloud-init pour terraform
#   - qemu-guest-agent pour Proxmox
# ──────────────────────────────────────────────


source "proxmox-iso" "tpl-ubuntu-2404" {
  # Proxmox connection
  proxmox_url              = var.proxmox_api_url
  username                 = var.proxmox_api_token_id
  token                    = var.proxmox_api_token_secret
  node                     = var.proxmox_node
  insecure_skip_tls_verify = var.proxmox_skip_tls_verify
  pool                     = var.pool

  # Template metadata
  vm_name              = var.template_name
  template_description = var.template_description
  tags                 = var.template_tags
  vm_id                = var.vm_id

  # ISO
  boot_iso {
    unmount      = true
    iso_file     = var.iso_file
    iso_checksum = var.iso_checksum
  }

  # Système
  qemu_agent      = true
  scsi_controller = "virtio-scsi-single"
  os              = "l26"
  cpu_type        = "host"
  cores           = var.vm_cores
  memory          = var.vm_memory

  # Cloud-init drive, pour Terraform
  cloud_init              = true
  cloud_init_storage_pool = var.vm_storage_pool

  # Disk
  disks {
    type         = "scsi"
    disk_size    = var.vm_disk_size
    storage_pool = var.vm_storage_pool
    format       = "raw"
  }

  # Network
  network_adapters {
    model    = "virtio"
    bridge   = var.vm_bridge
    firewall = false
  }

  # Boot commandes et envoie l'autoinstall via le HTPP serveur de Packer.
  # Les paramètres du kernel permettent de dire à l'installeur Ubuntu où trouver la configuration d'autoinstall
  http_directory = "http"
  boot_wait      = "10s"
  boot_command = [
    "<esc><wait>",
    "e<wait>",
    "<down><down><down><end>",
    " autoinstall ds=nocloud-net\\;s=http://{{ .HTTPIP }}:{{ .HTTPPort }}/",
    "<f10>"
  ]

  # SSH
  ssh_username           = var.ssh_username
  ssh_password           = var.ssh_password
  ssh_timeout            = var.ssh_timeout
  ssh_handshake_attempts = 20
}

build {
  name    = "ubuntu-2404"
  sources = ["source.proxmox-iso.tpl-ubuntu-2404"]

  # Attend que cloud init finisse avant de lancer le provisioner.
  provisioner "shell" {
    inline = ["cloud-init status --wait"]
  }

  # Permet de "clean" la VM, hardening et apt packages.
  provisioner "shell" {
    scripts = [
      "./scripts/01-update.sh",
      "./scripts/02-cloud-init-prep.sh",
      "./scripts/03-cleanup.sh",
    ]
  }
}