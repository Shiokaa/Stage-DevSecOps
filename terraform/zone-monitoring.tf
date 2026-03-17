# ──────────────────────────────────────────────
# VM Definitions
# ──────────────────────────────────────────────
# Dans ce fichier on peut ajouter le nombre de VM que l'on veut. Il suffit de rajouter des blocs "module".
# On peut très bien aussi séparé en plusieurs fichier pour plus de lisibilité.
# ──────────────────────────────────────────────

# Zone Monitoring

# VM Prometheus : 
module "prometheus" {
  source = "./modules/vm"

  name           = "prometheus"
  target_node    = "node2"
  template_name  = "ubuntu-2404-template"
  cores          = 2
  memory         = 2048
  disk_size      = "20G"
  ip_config      = "ip=192.168.10.52/24,gw=192.168.10.247"
  ci_user        = "admin"
  ssh_public_key = var.ssh_public_key
}

# VM Grafana : 
module "grafana" {
  source = "./modules/vm"

  name           = "grafana"
  target_node    = "node2"
  template_name  = "ubuntu-2404-template"
  cores          = 2
  memory         = 2048
  disk_size      = "20G"
  ip_config      = "ip=192.168.10.68/24,gw=192.168.10.247"
  ci_user        = "admin"
  ssh_public_key = var.ssh_public_key
}

# VM Loki
module "loki" {
  source = "./modules/vm"

  name           = "loki"
  target_node    = "node2"
  template_name  = "ubuntu-2404-template"
  cores          = 2
  memory         = 2048
  disk_size      = "20G"
  ip_config      = "ip=192.168.10.7/24,gw=192.168.10.247"
  ci_user        = "admin"
  ssh_public_key = var.ssh_public_key
}
