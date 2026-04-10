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

variable "ssh_user" {
  type        = string
  sensitive   = true
  description = "SSH User"
}

variable "ssh_key" {
  type        = string
  sensitive   = true
  description = "SSH Key"
}

# Cloud-init
variable "ci_user" {
  type        = string
  description = "User Cloud-Init"
}

variable "ci_ssh_keys" {
  type        = list(string)
  description = "Liste des clés SSH"
}
