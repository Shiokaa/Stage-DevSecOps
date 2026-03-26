# ──────────────────────────────────────────────
# VM Module — Proxmox resource réutilisable
# ──────────────────────────────────────────────

terraform {
  required_providers {
    proxmox = {
      source  = "telmate/proxmox"
      version = ">= 3.0.2-rc07"
    }
  }
}

resource "proxmox_vm_qemu" "vm" {
  count       = var.vm_count
  name        = var.vm_count > 1 ? "${var.name}-${count.index + 1}" : var.name
  description = var.description
  target_node = var.target_node
  clone       = var.template_name
  full_clone  = true
  vmid        = var.vmid_start != null ? var.vmid_start + count.index : null
  agent       = 1
  os_type     = "cloud-init"
  cpu {
    cores = var.cores
  }
  memory = var.memory
  scsihw = "virtio-scsi-single"
  pool   = var.pool

  # Disk — Redimensionne la taille du disque cloné s'il est plus grand que le modèle
  disks {
    ide {
      ide2 {
        cloudinit {
          storage = var.storage_pool
        }
      }
    }
    scsi {
      scsi0 {
        disk {
          size    = var.disk_size
          storage = var.storage_pool
        }
      }
    }
  }

  # Réseau
  network {
    id     = 0
    model  = "virtio"
    bridge = var.bridge
  }

  # Cloud-init configuration
  ipconfig0  = var.ip_config
  nameserver = var.nameserver
  ciuser     = var.ci_user
  cipassword = var.ci_password
  sshkeys    = "${var.ssh_public_key}\n"

  lifecycle {
    ignore_changes = [
      network,
      description,
    ]
  }
}
