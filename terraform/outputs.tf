# ──────────────────────────────────────────────
# Terraform — Outputs
# ──────────────────────────────────────────────

locals {
  all_vm_names = concat(
    module.bastion.vm_names,
    module.reverse-proxy.vm_names,
    module.ci-cd.vm_names,
  )

  all_vm_ips = concat(
    module.bastion.vm_ips,
    module.reverse-proxy.vm_ips,
    module.ci-cd.vm_ips,
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
