# ──────────────────────────────────────────────
# Terraform — Outputs
# ──────────────────────────────────────────────

locals {
  all_vm_names = concat(
    module.bastion.vm_ids,
    module.db.vm_ids,
    module.prometheus.vm_ids,
    module.loki.vm_ids,
    module.grafana.vm_ids,
    module.runner.vm_ids,
    module.dev-web.vm_ids,
    module.dev-db.vm_ids,
    module.backup.vm_ids,
    module.web.vm_ids,
    module.proxy.vm_ids
  )

  all_vm_ips = concat(
    module.bastion.vm_names,
    module.db.vm_names,
    module.prometheus.vm_names,
    module.loki.vm_names,
    module.grafana.vm_names,
    module.runner.vm_names,
    module.dev-web.vm_names,
    module.dev-db.vm_names,
    module.backup.vm_names,
    module.web.vm_names,
    module.proxy.vm_names
  )
}

output "vm_ips" {
  value       = local.all_vm_ips
  description = "Adresses IP des VMs déployés"
}

output "vm_names" {
  value       = local.all_vm_names
  description = "Nom des VMs déployés"
}
