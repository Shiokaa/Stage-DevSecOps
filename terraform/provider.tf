provider "proxmox" {
  endpoint  = "https://${var.proxmox_endpoint}:8006"
  api_token = var.api_token_secret

  insecure = true # car un certificat TLS auto-signé est utilisé
  ssh {
    agent    = true
    username = "tom-ssh"
  }
}