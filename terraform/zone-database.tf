# ──────────────────────────────────────────────
# VM Definitions
# ──────────────────────────────────────────────
# Dans ce fichier on peut ajouter le nombre de VM que l'on veut. Il suffit de rajouter des blocs "module".
# On peut très bien aussi séparé en plusieurs fichier pour plus de lisibilité.
# ──────────────────────────────────────────────

# Zone Database


module "db" {
  source = "./modules/vm"

  hostname    = "stage-db"
  domain      = "tom.lan"
  description = "Base de données principale - Environnement Staging"
  vm_id       = 8201
  tags        = ["database", "staging", "primary"]

  cpu_sockets = 1
  cpu_cores   = 4
  memory      = 8192
  disk = {
    storage = "local-lvm"
    size    = 50
  }

  ip_config = "172.16.20.1/24"
  gateway   = "172.16.20.254"
  bridge    = "ZoneDB"

  ci_user     = var.ci_user
  ci_ssh_keys = var.ci_ssh_keys
}

# VM backup : 
module "backup" {
  source = "./modules/vm"

  hostname    = "stage-db-backup"
  domain      = "tom.lan"
  description = "Serveur de sauvegarde de la base de données - Environnement Staging"
  vm_id       = 8202
  tags        = ["database", "staging", "backup"]

  cpu_sockets = 1
  cpu_cores   = 2
  memory      = 4096
  disk = {
    storage = "local-lvm"
    size    = 50
  }

  ip_config = "172.16.20.2/24"
  gateway   = "172.16.20.254"
  bridge    = "ZoneDB"

  ci_user     = var.ci_user
  ci_ssh_keys = var.ci_ssh_keys
  depends_on  = [module.db]
}
