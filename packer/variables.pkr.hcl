# ──────────────────────────────────────────────
# Packer Variables
# ──────────────────────────────────────────────

# Proxmox connection
variable "proxmox_api_url" {
  type        = string
  description = "Proxmox API URL (ex: https://proxmox:8006/api2/json)"
}

variable "proxmox_api_token_id" {
  type        = string
  description = "Proxmox API token ID (ex: user@pam!token-name)"
}

variable "proxmox_api_token_secret" {
  type        = string
  sensitive   = true
  description = "Proxmox API token secret"
}

variable "proxmox_node" {
  type        = string
  default     = "node2"
  description = "Node Proxmox ciblée"
}

variable "proxmox_skip_tls_verify" {
  type        = bool
  default     = true
  description = "Skip la vérification TLS (mettre en false en production)"
}

variable "pool" {
  type        = string
  default     = "tom-pool"
  description = "Pool custom si nécessaire"
}

# VM template paramètres
variable "template_name" {
  type        = string
  default     = "ubuntu-2404-template"
  description = "Nom de la VM template créée"
}

variable "template_description" {
  type        = string
  default     = "Ubuntu 24.04 LTS template built with Packer"
  description = "Template description"
}

variable "template_tags" {
  type        = string
  default     = "template;ubuntu;2404"
  description = "Tags de la VM template"
}

variable "vm_id" {
  type        = number
  default     = 9000
  description = "L'ID de la VM (Grand nombre pour éviter les conflits avec les autres VMS"
}

# ISO
variable "iso_file" {
  type        = string
  default     = "Backup-Node1:iso/ubuntu-24.04.3-live-server-amd64.iso"
  description = "Chemin vers l'iso ciblé"
}

variable "iso_checksum" {
  type        = string
  default     = "none"
  description = "ISO checksum (ex: sha256:abc123...). On utilise 'none' pour skip"
}

# Hardware
variable "vm_cores" {
  type        = number
  default     = 2
  description = "Nombre de coeur du CPU"
}

variable "vm_memory" {
  type        = number
  default     = 2048
  description = "Mémoire en MB"
}

variable "vm_disk_size" {
  type        = string
  default     = "20G"
  description = "Taille du disque en GB"
}

variable "vm_storage_pool" {
  type        = string
  default     = "local-lvm"
  description = "Le stockage du disque sur Proxmox"
}

# Réseau
variable "vm_bridge" {
  type        = string
  default     = "vmbr0"
  description = "Pont réseau"
}

# SSH
variable "ssh_username" {
  type        = string
  default     = "ubuntu"
  description = "SSH de l'utilisateur créé pendant l'autoinstall"
}

variable "ssh_password" {
  type        = string
  sensitive   = true
  description = "SSH mot de passe (enlever par:  cloud-init reset)"
}

variable "ssh_timeout" {
  type        = string
  default     = "30m"
  description = "SSH timeout"
}
