# ──────────────────────────────────────────────
# VM Definitions
# ──────────────────────────────────────────────
# Dans ce fichier on peut ajouter le nombre de VM que l'on veut. Il suffit de rajouter des blocs "module".
# On peut très bien aussi séparé en plusieurs fichier pour plus de lisibilité.
# ──────────────────────────────────────────────

# Zone Infra

# VM bastion : 
module "bastion" {
  source = "./modules/vm"

  hostname    = "stage-bastion"
  domain      = "tom.lan"
  description = "Bastion d'accès sécurisé (Point d'entrée admin) - Environnement Staging"
  vm_id       = 8501
  tags        = ["bastion", "staging", "infra", "security"]

  cpu_sockets = 1
  cpu_cores   = 2
  memory      = 2048
  disk = {
    storage = "local-lvm"
    size    = 20
  }

  ip_config = "172.16.50.1/24"
  gateway   = "172.16.50.254"
  bridge    = "ZoneInfra"

  ci_user     = var.ci_user
  ci_ssh_keys = var.ci_ssh_keys
}
