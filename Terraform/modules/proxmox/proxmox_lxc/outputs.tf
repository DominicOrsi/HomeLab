output "container_id" {
  value = proxmox_virtual_environment_container.lxc_container.vm_id
}

output "container_ips" {
  description = "The assigned IP addresses of the container"
  value       = proxmox_virtual_environment_container.lxc_container.ipv4
}