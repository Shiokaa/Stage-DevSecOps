# ──────────────────────────────────────────────
# Terraform — Variables
# ──────────────────────────────────────────────

# Proxmox connection
variable "proxmox_api_url" {
  type        = string
  description = "Proxmox API URL"
}

variable "proxmox_api_token_id" {
  type        = string
  description = "Proxmox API token ID"
}

variable "proxmox_api_token_secret" {
  type        = string
  sensitive   = true
  description = "Proxmox API token secret"
}

variable "proxmox_skip_tls_verify" {
  type        = bool
  default     = true
  description = "Skip la vérification TLS (mettre en false en production)"
}

# SSH
variable "ssh_public_key" {
  type        = string
  default     = "~/.ssh/id_ed25519.pub"
  description = "SSH public key pour l'accès aux VMs"
}
