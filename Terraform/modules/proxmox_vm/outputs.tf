output "vm_id" {
  description = "The Proxmox VM ID"
  value       = proxmox_virtual_environment_vm.vm_instance.vm_id
}

output "vm_name" {
  description = "The name of the VM"
  value       = proxmox_virtual_environment_vm.vm_instance.name
}

output "ip_address" {
  description = "The first IPv4 address reported by the guest agent"
  # Note: index [0] is usually the loopback, [1] is typically the first NIC
  value       = proxmox_virtual_environment_vm.vm_instance.ipv4_addresses[1][0]
}

output "all_ips" {
  description = "All IP addresses assigned to the VM"
  value       = proxmox_virtual_environment_vm.vm_instance.ipv4_addresses
}