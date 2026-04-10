# ──────────────────────────────────────────────
# VM Definitions
# ──────────────────────────────────────────────
# Dans ce fichier on peut ajouter le nombre de VM que l'on veut. Il suffit de rajouter des blocs "module".
# On peut très bien aussi séparé en plusieurs fichier pour plus de lisibilité.
# ──────────────────────────────────────────────

# Zone Dev

/* # VM database-dev
module "database-dev" {
  source = "./modules/vm"

  name           = "stage-database-dev"
  target_node    = "node2"
  template_name  = "ubuntu-2404-template"
  cores          = 2
  memory         = 2048
  disk_size      = "20G"
  bridge         = "ZoneDev"
  ip_config      = "ip=172.16.30.1/24,gw=172.16.30.254"
  nameserver     = "tom.lan"
  ci_user        = "admin"
  ci_password    = var.ci_password
  ssh_public_key = file(var.ssh_public_key)
}

# VM server-web-dev : 
module "server-web-dev" {
  source = "./modules/vm"

  name           = "stage-server-web-dev"
  target_node    = "node2"
  template_name  = "ubuntu-2404-template"
  cores          = 2
  memory         = 2048
  disk_size      = "20G"
  bridge         = "ZoneDev"
  ip_config      = "ip=172.16.30.2/24,gw=172.16.30.254"
  nameserver     = "tom.lan"
  ci_user        = "admin"
  ci_password    = var.ci_password
  ssh_public_key = file(var.ssh_public_key)
}

# VM ci-cd : 
module "ci-cd" {
  source = "./modules/vm"

  name           = "stage-ci-cd"
  target_node    = "node2"
  template_name  = "ubuntu-2404-template"
  cores          = 2
  memory         = 2048
  disk_size      = "20G"
  bridge         = "ZoneDev"
  ip_config      = "ip=172.16.30.3/24,gw=172.16.30.254"
  nameserver     = "tom.lan"
  ci_user        = "admin"
  ci_password    = var.ci_password
  ssh_public_key = file(var.ssh_public_key)
}
 */