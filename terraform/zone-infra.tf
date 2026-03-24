# ──────────────────────────────────────────────
# VM Definitions
# ──────────────────────────────────────────────
# Dans ce fichier on peut ajouter le nombre de VM que l'on veut. Il suffit de rajouter des blocs "module".
# On peut très bien aussi séparé en plusieurs fichier pour plus de lisibilité.
# ──────────────────────────────────────────────

# Zone Infra

# VM gateway : 
/* module "gateway" {
  source = "./modules/vm"

  name           = "stage-gateway"
  target_node    = "node2"
  template_name  = "ubuntu-2404-template"
  cores          = 2
  memory         = 2048
  disk_size      = "20G"
  ip_config      = "ip=172.16.50.254/24,gw=172.16.50.254"
  ci_user        = "admin"
  ssh_public_key = var.ssh_public_key
} */

# VM dns : 
module "dns" {
  source = "./modules/vm"

  name           = "stage-dns"
  target_node    = "node2"
  template_name  = "ubuntu-2404-template"
  cores          = 2
  memory         = 2048
  disk_size      = "20G"
  bridge         = "ZoneInfra"
  ip_config      = "ip=172.16.50.1/24,gw=172.16.50.254"
  ci_user        = "admin"
  ssh_public_key = file(var.ssh_public_key)
}

# VM bastion : 
module "bastion" {
  source = "./modules/vm"

  name           = "stage-bastion"
  target_node    = "node2"
  template_name  = "ubuntu-2404-template"
  cores          = 2
  memory         = 2048
  disk_size      = "20G"
  bridge         = "ZoneInfra"
  ip_config      = "ip=172.16.50.2/24,gw=172.16.50.254"
  ci_user        = "admin"
  ssh_public_key = file(var.ssh_public_key)
}
