# ──────────────────────────────────────────────
# VM Module — Variables
# ──────────────────────────────────────────────

# VM paramètres
variable "name" {
  type        = string
  description = "VM nom"
}

variable "description" {
  type        = string
  default     = ""
  description = "VM description"
}

# Proxmox connection
variable "target_node" {
  type        = string
  default     = "node2"
  description = "Node Proxmox ciblée"
}

variable "pool" {
  type        = string
  default     = "tom-pool"
  description = "Pool custom si nécessaire"
}

# Clone
variable "template_name" {
  type        = string
  default     = "ubuntu-2404-template"
  description = "Nom de la template packer à cloner"
}

variable "vm_count" {
  type        = number
  default     = 1
  description = "Nombre de VMs à créer"
}

variable "vmid_start" {
  type        = number
  default     = null
  description = "ID de la VM de départ (null = attribution automatique)"
}

# Hardware
variable "cores" {
  type        = number
  default     = 2
  description = "Nombre de coeur du CPU"
}

variable "memory" {
  type        = number
  default     = 2048
  description = "Mémoire en MB"
}

variable "disk_size" {
  type        = string
  default     = "20G"
  description = "Taille du disque en GB"
}

variable "storage_pool" {
  type        = string
  default     = "local-lvm"
  description = "Le stockage du disque sur Proxmox"
}

# Réseau
variable "bridge" {
  type        = string
  default     = "vmbr0"
  description = "Pont réseau"
}

variable "ip_config" {
  type        = string
  default     = "ip=dhcp"
  description = "IP configuration (ex: ip=10.0.0.10/24,gw=10.0.0.1 ou ip=dhcp)"
}

variable "nameserver" {
  type        = string
  default     = ""
  description = "DNS nameserver"
}

# Cloud-init
variable "ci_user" {
  type        = string
  default     = "admin"
  description = "Cloud-init utilisateur"
}

# SSH
variable "ssh_public_key" {
  type        = string
  default     = "~/.ssh/id_ed25519.pub"
  description = "SSH public key pour l'utilisateur cloud-init"
}
