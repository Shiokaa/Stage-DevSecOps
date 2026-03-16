# ──────────────────────────────────────────────
# Terraform — Outputs
# ──────────────────────────────────────────────

locals {
  all_vm_names = concat(
    module.test_vm.vm_names,
    module.test_vm_2.vm_names,
  )

  all_vm_ips = concat(
    module.test_vm.vm_ips,
    module.test_vm_2.vm_ips,
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
