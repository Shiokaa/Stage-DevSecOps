variable "api_token_secret" {
  description = "Token privé de l'API proxmox"
  type        = string
}

variable "proxmox_endpoint" {
  description = "Proxmox endpoint"
  type        = string
  default     = "192.168.10.250"
}

variable "target_node" {
  description = "Proxmox node"
  type        = string
  default     = "node1"
}

variable "vm_hostname" {
  description = "VM hostname"
  type        = string
  default     = "tom-test"
}

variable "ssh_public_key" {
  description = "Chemin vers la clé publique SSH"
  type        = string
  default     = "~/.ssh/id_ed25519.pub"
}

variable "domain" {
  description = "VM domain"
  type        = string
  default     = "tom-local"
}

variable "vm_tags" {
  description = "VM tags"
  type        = list(string)
  default     = ["ubuntu", "test"]
}

variable "template_tag" {
  description = "Template tag"
  type        = string
  default     = "ubuntu-2204"
}


variable "additionnal_disks" {
  description = "Additionnal disks"
  type = list(object({
    storage = string
    size    = number
  }))
  default = []
}