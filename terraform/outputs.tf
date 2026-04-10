# ──────────────────────────────────────────────
# Terraform — Outputs
# ──────────────────────────────────────────────

locals {
  all_vm_names = concat(
    /*     module.database.vm_names,
    module.backup.vm_names,
    module.database-dev.vm_names,
    module.server-web-dev.vm_names,
    module.ci-cd.vm_names,
    module.reverse-proxy.vm_names,
    module.server-web.vm_names,
    module.dns.vm_names, */
    module.bastion.vm_names,
    /*     module.grafana.vm_names,
    module.loki.vm_names,
    module.prometheus.vm_names */
  )

  all_vm_ips = concat(
    /*     module.database.vm_ips,
    module.backup.vm_ips,
    module.database-dev.vm_ips,
    module.server-web-dev.vm_ips,
    module.ci-cd.vm_ips,
    module.reverse-proxy.vm_ips,
    module.server-web.vm_ips,
    module.dns.vm_ips, */
    module.bastion.vm_ips,
    /*     module.grafana.vm_ips,
    module.loki.vm_ips,
    module.prometheus.vm_ips */
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

output "debug_ssh_keys" {
  value = module.bastion.debug_ci_ssh_keys
}
