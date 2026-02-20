# Container/LXC Module
# module "fedora_lxc" {
#   source = "./proxmox_lxc"
#   node_name = "talos"
#   hostname = "homer"

#   ct_id = 1000

#   user_password = """
#   ssh_public_key = var.ssh_public_key
# }

# output "fedora_lxc_ip" {
#   value = module.fedora_lxc.container_ips
# }


# VM Module
module "rocky_vm" {
  source      = "./proxmox_vm"
  node_name   = "talos"
  template_id = 9001
  vm_name     = "podman-host"

  # Hardware settings overridden here
  ssh_public_key = var.ssh_public_key
}

output "rocky_vm_ip" {
  value = module.rocky_vm.ip_address
}