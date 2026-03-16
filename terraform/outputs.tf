# ──────────────────────────────────────────────
# Terraform — Outputs
# ──────────────────────────────────────────────

locals {
  all_vm_names = concat(
    module.bastion.vm_names,
    module.reverse-proxy.vm_names,
    module.ci-cd.vm_names,
    module.dev.vm_names,
    module.database.vm_names,
    module.prometheus.vm_names,
    module.grafana.vm_names,
    module.loki.vm_names,
  )

  all_vm_ips = concat(
    module.bastion.vm_ips,
    module.reverse-proxy.vm_ips,
    module.ci-cd.vm_ips,
    module.dev.vm_ips,
    module.database.vm_ips,
    module.prometheus.vm_ips,
    module.grafana.vm_ips,
    module.loki.vm_ips,
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
