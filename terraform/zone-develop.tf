# ──────────────────────────────────────────────
# VM Definitions
# ──────────────────────────────────────────────
# Dans ce fichier on peut ajouter le nombre de VM que l'on veut. Il suffit de rajouter des blocs "module".
# On peut très bien aussi séparé en plusieurs fichier pour plus de lisibilité.
# ──────────────────────────────────────────────

# Zone Dev

# VM database-dev
module "dev-db" {
  source = "./modules/vm"

  hostname    = "stage-dev-db"
  domain      = "tom.lan"
  description = "Base de données - Environnement de Développement"
  vm_id       = 8301
  tags        = ["database", "dev"]

  cpu_sockets = 1
  cpu_cores   = 2
  memory      = 4096
  disk = {
    storage = "local-lvm"
    size    = 50
  }

  ip_config = "172.16.30.1/24"
  gateway   = "172.16.30.254"
  bridge    = "ZoneDev"

  ci_user     = var.ci_user
  ci_ssh_keys = var.ci_ssh_keys
  depends_on  = [module.dev-web]
}

# VM server-web-dev : 
module "dev-web" {
  source = "./modules/vm"

  hostname    = "stage-dev-web"
  domain      = "tom.lan"
  description = "Serveur Web Frontend/Backend - Environnement de Développement"
  vm_id       = 8302
  tags        = ["web", "dev"]

  cpu_sockets = 1
  cpu_cores   = 2
  memory      = 2048
  disk = {
    storage = "local-lvm"
    size    = 30
  }

  ip_config = "172.16.30.2/24"
  gateway   = "172.16.30.254"
  bridge    = "ZoneDev"

  ci_user     = var.ci_user
  ci_ssh_keys = var.ci_ssh_keys
}

# VM ci-cd : 
module "runner" {
  source = "./modules/vm"

  hostname    = "stage-runner"
  domain      = "tom.lan"
  description = "Agent d'exécution CI/CD (Pipelines, Builds Docker)"
  vm_id       = 8303
  tags        = ["cicd", "runner", "dev"]

  cpu_sockets = 1
  cpu_cores   = 4
  memory      = 8192
  disk = {
    storage = "local-lvm"
    size    = 60
  }

  ip_config = "172.16.30.3/24"
  gateway   = "172.16.30.254"
  bridge    = "ZoneDev"

  ci_user     = var.ci_user
  ci_ssh_keys = var.ci_ssh_keys
}
