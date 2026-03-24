# ──────────────────────────────────────────────
# VM Definitions
# ──────────────────────────────────────────────
# Dans ce fichier on peut ajouter le nombre de VM que l'on veut. Il suffit de rajouter des blocs "module".
# On peut très bien aussi séparé en plusieurs fichier pour plus de lisibilité.
# ──────────────────────────────────────────────

# Zone Monitoring

# VM grafana : 
module "grafana" {
  source = "./modules/vm"

  name           = "stage-grafana"
  target_node    = "node2"
  template_name  = "ubuntu-2404-template"
  cores          = 2
  memory         = 2048
  disk_size      = "20G"
  bridge         = "ZoneMoni"
  ip_config      = "ip=172.16.40.1/24,gw=172.16.40.254"
  ci_user        = "admin"
  ssh_public_key = file(var.ssh_public_key)
}

# VM loki
module "loki" {
  source = "./modules/vm"

  name           = "stage-loki"
  target_node    = "node2"
  template_name  = "ubuntu-2404-template"
  cores          = 2
  memory         = 2048
  disk_size      = "20G"
  bridge         = "ZoneMoni"
  ip_config      = "ip=172.16.40.2/24,gw=172.16.40.254"
  ci_user        = "admin"
  ssh_public_key = file(var.ssh_public_key)
}

# VM prometheus : 
module "prometheus" {
  source = "./modules/vm"

  name           = "stage-prometheus"
  target_node    = "node2"
  template_name  = "ubuntu-2404-template"
  cores          = 2
  memory         = 2048
  disk_size      = "20G"
  bridge         = "ZoneMoni"
  ip_config      = "ip=172.16.40.3/24,gw=172.16.40.254"
  ci_user        = "admin"
  ssh_public_key = file(var.ssh_public_key)
}
