# ──────────────────────────────────────────────
# VM Definitions
# ──────────────────────────────────────────────
# Dans ce fichier on peut ajouter le nombre de VM que l'on veut. Il suffit de rajouter des blocs "module".
# On peut très bien aussi séparé en plusieurs fichier pour plus de lisibilité.
# ──────────────────────────────────────────────

# Zone Database

/* # VM database 
module "database" {
  source = "./modules/vm"

  name           = "stage-database"
  target_node    = "node2"
  template_name  = "ubuntu-2404-template"
  cores          = 2
  memory         = 2048
  disk_size      = "20G"
  bridge         = "ZoneDB"
  ip_config      = "ip=172.16.20.1/24,gw=172.16.20.254"
  nameserver     = "tom.lan"
  ci_user        = "admin"
  ci_password    = var.ci_password
  ssh_public_key = file(var.ssh_public_key)
}

# VM backup : 
module "backup" {
  source = "./modules/vm"

  name           = "stage-backup"
  target_node    = "node2"
  template_name  = "ubuntu-2404-template"
  cores          = 2
  memory         = 2048
  disk_size      = "20G"
  bridge         = "ZoneDB"
  ip_config      = "ip=172.16.20.2/24,gw=172.16.20.254"
  nameserver     = "tom.lan"
  ci_user        = "admin"
  ci_password    = var.ci_password
  ssh_public_key = file(var.ssh_public_key)
}
 */