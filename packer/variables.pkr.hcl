variable "proxmox_token_id" {
  type      = string
  sensitive = true
}

variable "proxmox_token_secret" {
  type      = string
  sensitive = true
}

variable "ssh_username" {
  type    = string
  default = "tom"
}

variable "ssh_password" {
  type      = string
  sensitive = true
}

variable "proxmox_endpoint" {
  description = "Proxmox endpoint"
  type        = string
  default     = "192.168.10.250"
}
