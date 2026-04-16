# ──────────────────────────────────────────────
# VM Module — Variables
# ──────────────────────────────────────────────

# VM paramètres
variable "hostname" {
  type        = string
  description = "VM nom"
}

variable "description" {
  type        = string
  description = "VM description"
}

variable "vm_count" {
  type        = number
  default     = 1
  description = "Nombre de VMs à créer"
}

variable "tags" {
  type        = list(string)
  description = "Tags de la VM"
}

variable "vm_id" {
  type        = number
  description = "Id de la VM"
}

variable "on_boot" {
  type        = bool
  default     = false
  description = "Auto start de la VM lorsque la node se démarre"
}

variable "started" {
  type        = bool
  default     = false
  description = "Auto start de la VM lors de la création"
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
variable "template_node" {
  type        = string
  default     = "node2"
  description = "Node de la VM template"
}

variable "template_id" {
  type        = number
  default     = 9000
  description = "Id de la template à cloner"
}

variable "full_clone" {
  type        = bool
  default     = true
  description = "Full clone"
}

# Agent
variable "qemu_guest_agent" {
  type        = bool
  default     = true
  description = "Qemu Guest Agent"
}

# Hardware

## CPU
variable "cpu_type" {
  type        = string
  default     = "x86-64-v2-AES"
  description = "Type du CPU"
}

variable "cpu_cores" {
  type        = number
  default     = 1
  description = "Nombre de coeurs du CPU"
}

variable "cpu_sockets" {
  type        = number
  default     = 1
  description = "Nombre de sockets du CPU"
}

## Memory

variable "memory" {
  type        = number
  default     = 2048
  description = "Nombre de mémoire en MB"
}

## Disk
variable "disk" {
  description = "Taille du disk en GB"
  type = object({
    storage = string
    size    = number
  })
  default = {
    storage = "local-lvm"
    size    = 30
  }
}

# Réseau
variable "bridge" {
  type        = string
  default     = "vmbr0"
  description = "Pont réseau"
}

variable "ip_config" {
  type        = string
  description = "IP de la VM ('dhcp' pour une IP avec dhcp)"
}

variable "gateway" {
  type        = string
  description = "IP gateway de la VM"
}

variable "servers" {
  type        = list(string)
  default     = ["172.16.50.254"]
  description = "Liste des serveurs DNS"
}

variable "domain" {
  type        = string
  description = "Domain du DNS"
}
# Cloud-init
variable "content_type" {
  type        = string
  default     = "snippets"
  description = "Content Type"
}

variable "datastore" {
  type        = string
  default     = "local"
  description = "Storage du fichier"
}

variable "ci_user" {
  type        = string
  description = "Utilisateur de la VM"
}

variable "ci_ssh_keys" {
  type        = list(string)
  description = "Liste des clés SSH pour le cloud-init"
}
