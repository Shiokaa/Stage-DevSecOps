# ──────────────────────────────────────────────
# VM Module — Outputs
# ──────────────────────────────────────────────

output "vm_ids" {
  value       = proxmox_vm_qemu.vm[*].vmid
  description = "Liste des IDs des VMs"
}

output "vm_names" {
  value       = proxmox_vm_qemu.vm[*].name
  description = "Liste des noms des VMs"
}

output "vm_ips" {
  value       = proxmox_vm_qemu.vm[*].default_ipv4_address
  description = "Liste des adresses IP des VM (nécessite qemu-guest-agent)"
}
