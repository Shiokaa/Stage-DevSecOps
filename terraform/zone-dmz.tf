# ──────────────────────────────────────────────
# VM Definitions
# ──────────────────────────────────────────────
# Dans ce fichier on peut ajouter le nombre de VM que l'on veut. Il suffit de rajouter des blocs "module".
# On peut très bien aussi séparé en plusieurs fichier pour plus de lisibilité.
# ──────────────────────────────────────────────

# Zone DMZ - Exposée 

/* # VM reverse-proxy : 
module "reverse-proxy" {
  source = "./modules/vm"

  name           = "stage-reverse-proxy"
  target_node    = "node2"
  template_name  = "ubuntu-2404-template"
  cores          = 2
  memory         = 2048
  disk_size      = "20G"
  bridge         = "ZoneDmz"
  ip_config      = "ip=172.16.10.1/24,gw=172.16.10.254"
  nameserver     = "tom.lan"
  ci_user        = "admin"
  ci_password    = var.ci_password
  ssh_public_key = file(var.ssh_public_key)
}

# VM server-web : 
module "server-web" {
  source = "./modules/vm"

  name           = "stage-server-web"
  target_node    = "node2"
  template_name  = "ubuntu-2404-template"
  cores          = 2
  memory         = 2048
  disk_size      = "20G"
  bridge         = "ZoneDmz"
  ip_config      = "ip=172.16.10.2/24,gw=172.16.10.254"
  nameserver     = "tom.lan"
  ci_user        = "admin"
  ci_password    = var.ci_password
  ssh_public_key = file(var.ssh_public_key)
}
 */