source "proxmox-iso" "tpl-ubuntu-2204" {
  insecure_skip_tls_verify = true
  proxmox_url              = "https://${var.proxmox_endpoint}:8006/api2/json"
  username                 = var.proxmox_token_id
  token                    = var.proxmox_token_secret

  node = "node2"

  vm_name              = "tpl-ubuntu-2204"
  tags                 = "template;ubuntu-2204"
  template_description = "Ubuntu 22.04 Cloud Init template"
  os                   = "l26"
  sockets              = 1
  cores                = 2
  memory               = 2048
  pool                 = "tom-pool"

  bios                    = "ovmf"
  qemu_agent              = true
  cloud_init              = true
  cloud_init_storage_pool = "local-lvm"

  vga {
    type = "virtio"
  }

  scsi_controller = "virtio-scsi-pci"
  disks {
    disk_size    = "32G"
    format       = "raw"
    storage_pool = "local-lvm"
    type         = "scsi"
    ssd          = true
    discard      = true
  }

  efi_config {
    efi_storage_pool  = "local-lvm"
    pre_enrolled_keys = true
    efi_type          = "4m"
  }

  network_adapters {
    model    = "virtio"
    bridge   = "vmbr0"
    firewall = "false"
  }

  http_directory = "autoinstall/ubuntu2204"

  boot_iso {
    type             = "scsi"
    unmount          = true
    iso_file         = "Backup-Node1:iso/ubuntu-24.04.3-live-server-amd64.iso"
    iso_storage_pool = "local"
    iso_checksum     = "sha256:c3514bf0056180d09376462a7a1b4f213c1d6e8ea67fae5c25099c6fd3d8274b"
  }

  boot_wait = "15s"
  boot_command = [
    "<spacebar><wait><spacebar><wait><spacebar><wait><spacebar><wait><spacebar><wait>",
    "e<wait>",
    "<down><down><down><end>",
    " autoinstall ds=nocloud-net\\;s=http://{{ .HTTPIP }}:{{ .HTTPPort }}/",
    "<f10>"
  ]

  ssh_username = var.ssh_username
  ssh_password = var.ssh_password
  ssh_timeout  = "60m"
}

build {
  sources = ["proxmox-iso.tpl-ubuntu-2204"]
  provisioner "shell" {
    script       = "provisionners/postinstall-ubuntu.sh"
    pause_before = "10s"
    timeout      = "5m"
  }
}