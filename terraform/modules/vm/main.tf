# ──────────────────────────────────────────────
# VM Module — Proxmox resource réutilisable
# ──────────────────────────────────────────────

terraform {
  required_version = ">=1.5.0"
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = "0.100.0"
    }
  }
}

resource "proxmox_virtual_environment_file" "cloud_user_config" {
  content_type = var.content_type
  datastore_id = var.datastore
  node_name    = var.target_node

  source_raw {
    data = templatefile("${path.module}/cloud-init/user_data", {
      hostname    = var.hostname
      domain      = var.domain
      ci_user     = var.ci_user
      ci_ssh_keys = join("\n      - ", [for k in var.ci_ssh_keys : trimspace(startswith(k, "~/") ? file(pathexpand(k)) : k)])
    })

    file_name = "${var.hostname}.${var.domain}-ci-user.yml"
  }
}

resource "proxmox_virtual_environment_file" "cloud_meta_config" {
  content_type = var.content_type
  datastore_id = var.datastore
  node_name    = var.target_node

  source_raw {
    data = templatefile("${path.module}/cloud-init/meta_data",
      {
        instance_id    = sha1(var.hostname)
        local_hostname = var.hostname
      }
    )

    file_name = "${var.hostname}.${var.domain}-ci-meta_data.yml"
  }
}

resource "proxmox_virtual_environment_vm" "vm" {
  count       = var.vm_count
  name        = var.vm_count > 1 ? "${var.hostname}-${count.index + 1}.${var.domain}" : "${var.hostname}.${var.domain}"
  description = var.description
  tags        = var.tags
  vm_id       = var.vm_id + count.index
  on_boot     = var.on_boot
  started     = var.started

  node_name = var.target_node
  pool_id   = var.pool

  clone {
    node_name = var.template_node
    vm_id     = var.template_id
    full      = var.full_clone
  }

  agent {
    enabled = var.qemu_guest_agent
  }

  cpu {
    type    = var.cpu_type
    cores   = var.cpu_cores
    sockets = var.cpu_sockets
  }

  memory {
    dedicated = var.memory
  }

  boot_order    = ["scsi0"]
  scsi_hardware = "virtio-scsi-single"

  disk {
    interface    = "scsi0"
    iothread     = true
    datastore_id = var.disk.storage
    size         = var.disk.size
    discard      = "on"
  }

  network_device {
    bridge = var.bridge
    model  = "virtio"
  }

  lifecycle {
    ignore_changes = [
      network_device,
    ]
  }

  initialization {
    dns {
      domain  = var.domain
      servers = var.servers
    }

    ip_config {
      ipv4 {
        address = var.ip_config
        gateway = var.gateway
      }
    }

    datastore_id      = "local-lvm"
    interface         = "ide2"
    user_data_file_id = proxmox_virtual_environment_file.cloud_user_config.id
    meta_data_file_id = proxmox_virtual_environment_file.cloud_meta_config.id
  }
}
