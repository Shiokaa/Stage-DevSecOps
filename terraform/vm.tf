data "proxmox_virtual_environment_vms" "template" {
  node_name = var.target_node
  tags      = ["template", var.template_tag]
}

resource "proxmox_virtual_environment_file" "cloud_user_config" {
  content_type = "snippets"
  datastore_id = "local"
  node_name    = var.target_node

  source_raw {
    data = templatefile("cloud-init/user_data",
      {
        hostname       = var.vm_hostname
        domain         = var.domain
        ssh_public_key = trimspace(file(pathexpand(var.ssh_public_key)))
      }
    )

    file_name = "${var.vm_hostname}.${var.domain}-ci-user.yml"
  }
}

resource "proxmox_virtual_environment_file" "cloud_meta_config" {
  content_type = "snippets"
  datastore_id = "local"
  node_name    = var.target_node

  source_raw {
    data = templatefile("cloud-init/meta_data",
      {
        instance_id    = sha1(var.vm_hostname)
        local_hostname = var.vm_hostname

      }
    )

    file_name = "${var.vm_hostname}.${var.domain}-ci-meta_data.yml"
  }
}

resource "proxmox_virtual_environment_vm" "vm" {
  name      = "${var.vm_hostname}.${var.domain}"
  node_name = var.target_node
  pool_id   = "tom-pool"

  on_boot = true


  agent {
    enabled = true
  }

  tags = var.vm_tags

  cpu {
    type    = "x86-64-v2-AES"
    cores   = 1
    sockets = 1
    flags   = []
  }

  memory {
    dedicated = 2048
  }

  network_device {
    bridge = "vmbr0"
    model  = "virtio"
  }

  # Ignore changes to the network
  ## MAC address is generated on every apply, causing
  ## TF to think this needs to be rebuilt on every apply
  lifecycle {
    ignore_changes = [
      network_device,
    ]
  }

  boot_order    = ["scsi0"]
  scsi_hardware = "virtio-scsi-single"

  disk {
    interface    = "scsi0"
    iothread     = true
    datastore_id = "local-lvm"
    size         = 32
    discard      = "ignore"
  }

  clone {
    vm_id = data.proxmox_virtual_environment_vms.template.vms[0].vm_id
  }

  initialization {
    ip_config {
      ipv4 {
        address = "dhcp"
      }
    }

    datastore_id      = "local-lvm"
    interface         = "ide2"
    user_data_file_id = proxmox_virtual_environment_file.cloud_user_config.id
    meta_data_file_id = proxmox_virtual_environment_file.cloud_meta_config.id
  }


}