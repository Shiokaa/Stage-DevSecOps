# ──────────────────────────────────────────────
# VM Definitions
# ──────────────────────────────────────────────
# Dans ce fichier on peut ajouter le nombre de VM que l'on veut. Il suffit de rajouter des blocs "module".
# On peut très bien aussi séparé en plusieurs fichier pour plus de lisibilité.
# ──────────────────────────────────────────────

# VM d'exemple :
module "test_vm" {
  source = "./modules/vm"

  name           = "test-vm"
  target_node    = "node2"
  template_name  = "ubuntu-2404-template"
  cores          = 2
  memory         = 2048
  disk_size      = "20G"
  ip_config      = "ip=dhcp"
  ci_user        = "admin"
  ssh_public_key = var.ssh_public_key
}
