# ──────────────────────────────────────────────
# Terraform — Proxmox Provider
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

provider "proxmox" {
  endpoint  = var.proxmox_api_url
  api_token = "${var.proxmox_api_token_id}=${var.proxmox_api_token_secret}"
  insecure  = var.proxmox_skip_tls_verify
  ssh {
    username    = var.ssh_user
    private_key = file(var.ssh_key)
  }
}
