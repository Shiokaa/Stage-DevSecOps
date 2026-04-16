# ──────────────────────────────────────────────
# VM Definitions
# ──────────────────────────────────────────────
# Dans ce fichier on peut ajouter le nombre de VM que l'on veut. Il suffit de rajouter des blocs "module".
# On peut très bien aussi séparé en plusieurs fichier pour plus de lisibilité.
# ──────────────────────────────────────────────

# Zone Monitoring

# VM Grafana (Visualisation)
module "grafana" {
  source = "./modules/vm"

  hostname    = "stage-grafana"
  domain      = "tom.lan"
  description = "Dashboard et Visualisation (Grafana) - Staging"
  vm_id       = 8401
  tags        = ["monitoring", "grafana", "staging"]

  cpu_sockets = 1
  cpu_cores   = 2
  memory      = 2048
  disk = {
    storage = "local-lvm"
    size    = 20
  }

  ip_config = "172.16.40.1/24"
  gateway   = "172.16.40.254"
  bridge    = "ZoneMoni"

  ci_user     = "admin"
  ci_ssh_keys = var.ci_ssh_keys
  depends_on  = [module.bastion]
}

# VM Loki (Logs)
module "loki" {
  source = "./modules/vm"

  hostname    = "stage-loki"
  domain      = "tom.lan"
  description = "Agrégation de logs (Loki) - Staging"
  vm_id       = 8402
  tags        = ["monitoring", "loki", "staging", "logs"]

  cpu_sockets = 1
  cpu_cores   = 2
  memory      = 4096
  disk = {
    storage = "local-lvm"
    size    = 50
  }

  ip_config = "172.16.40.2/24"
  gateway   = "172.16.40.254"
  bridge    = "ZoneMoni"

  ci_user     = "admin"
  ci_ssh_keys = var.ci_ssh_keys
  depends_on  = [module.bastion]
}

# VM Prometheus (Métriques)
module "prometheus" {
  source = "./modules/vm"

  hostname    = "stage-prometheus"
  domain      = "tom.lan"
  description = "Collecte de métriques (Prometheus) - Staging"
  vm_id       = 8403
  tags        = ["monitoring", "prometheus", "staging", "metrics"]

  cpu_sockets = 1
  cpu_cores   = 2
  memory      = 4096
  disk = {
    storage = "local-lvm"
    size    = 50
  }

  ip_config = "172.16.40.3/24"
  gateway   = "172.16.40.254"
  bridge    = "ZoneMoni"

  ci_user     = "admin"
  ci_ssh_keys = var.ci_ssh_keys
  depends_on  = [module.bastion]
}
