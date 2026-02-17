variable "api_token_secret" {
  description = "Token privé de l'API proxmox"
  type        = string
}

variable "proxmox_endpoint" {
  description = "Proxmox endpoint"
  type        = string
  default     = "192.168.10.250"
}
