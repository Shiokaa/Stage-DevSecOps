# ──────────────────────────────────────────────
# VM Definitions
# ──────────────────────────────────────────────
# Dans ce fichier on peut ajouter le nombre de VM que l'on veut. Il suffit de rajouter des blocs "module".
# On peut très bien aussi séparé en plusieurs fichier pour plus de lisibilité.
# ──────────────────────────────────────────────

# Zone DMZ - Exposée 

# VM reverse-proxy
module "proxy" {
  source = "./modules/vm"

  hostname    = "stage-proxy"
  domain      = "tom.lan"
  description = "Reverse Proxy (Point d'entrée principal) - Environnement Staging"
  vm_id       = 8101
  tags        = ["proxy", "staging", "dmz"]

  cpu_sockets = 1
  cpu_cores   = 2
  memory      = 2048
  disk = {
    storage = "local-lvm"
    size    = 20
  }

  ip_config = "172.16.10.1/24"
  gateway   = "172.16.10.254"
  bridge    = "ZoneDmz"

  ci_user     = "admin"
  ci_ssh_keys = var.ci_ssh_keys
  depends_on  = [module.web]
}

# VM server-web
module "web" {
  source = "./modules/vm"

  hostname    = "stage-web"
  domain      = "tom.lan"
  description = "Serveur Web Applicatif - Environnement Staging"
  vm_id       = 8102
  tags        = ["web", "staging", "dmz"]

  cpu_sockets = 1
  cpu_cores   = 2
  memory      = 2048
  disk = {
    storage = "local-lvm"
    size    = 30
  }

  ip_config = "172.16.10.2/24"
  gateway   = "172.16.10.254"
  bridge    = "ZoneDmz"

  ci_user     = "admin"
  ci_ssh_keys = var.ci_ssh_keys
  depends_on  = [module.db]
}
