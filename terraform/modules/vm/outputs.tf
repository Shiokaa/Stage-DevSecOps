# ──────────────────────────────────────────────
# VM Module — Outputs
# ──────────────────────────────────────────────

output "vm_ids" {
  value       = proxmox_virtual_environment_vm.vm[*].vm_id
  description = "Liste des IDs des VMs"
}

output "vm_names" {
  value       = proxmox_virtual_environment_vm.vm[*].name
  description = "Liste des noms des VMs"
}

output "vm_ips" {
  value       = proxmox_virtual_environment_vm.vm[*].ipv4_addresses
  description = "Liste des adresses IP des VM (nécessite qemu-guest-agent)"
}

# modules/vm/outputs.tf
output "debug_ci_ssh_keys" {
  value = join("\n      - ", [for k in var.ci_ssh_keys : trimspace(startswith(k, "~/") ? file(pathexpand(k)) : k)])
}
