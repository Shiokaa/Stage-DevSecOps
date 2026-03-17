# ──────────────────────────────────────────────
# VM Definitions
# ──────────────────────────────────────────────
# Dans ce fichier on peut ajouter le nombre de VM que l'on veut. Il suffit de rajouter des blocs "module".
# On peut très bien aussi séparé en plusieurs fichier pour plus de lisibilité.
# ──────────────────────────────────────────────

# Zone DMZ - Exposée 

# VM Bastion : 
module "bastion" {
  source = "./modules/vm"

  name           = "bastion"
  target_node    = "node2"
  template_name  = "ubuntu-2404-template"
  cores          = 2
  memory         = 2048
  disk_size      = "20G"
  ip_config      = "ip=192.168.10.9/24,gw=192.168.10.247"
  ci_user        = "admin"
  ssh_public_key = var.ssh_public_key
}
# VM Reverse Proxy : 
module "reverse-proxy" {
  source = "./modules/vm"

  name           = "reverse-proxy"
  target_node    = "node2"
  template_name  = "ubuntu-2404-template"
  cores          = 2
  memory         = 2048
  disk_size      = "20G"
  ip_config      = "ip=192.168.10.48/24,gw=192.168.10.247"
  ci_user        = "admin"
  ssh_public_key = var.ssh_public_key
}

# VM CI/CD
module "ci-cd" {
  source = "./modules/vm"

  name           = "ci-cd"
  target_node    = "node2"
  template_name  = "ubuntu-2404-template"
  cores          = 2
  memory         = 2048
  disk_size      = "20G"
  ip_config      = "ip=192.168.10.10/24,gw=192.168.10.247"
  ci_user        = "admin"
  ssh_public_key = var.ssh_public_key
}
