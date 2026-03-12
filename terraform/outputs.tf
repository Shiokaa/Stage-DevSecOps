# ──────────────────────────────────────────────
# Terraform — Outputs
# ──────────────────────────────────────────────

output "vm_ips" {
  value       = module.test_vm.vm_ips
  description = "Adresses IP des VMs déployés"
}

output "vm_names" {
  value       = module.test_vm.vm_names
  description = "Nom des VMs déployés"
}
