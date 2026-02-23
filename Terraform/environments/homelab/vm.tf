# VM Module
module "proxmox_vm" {
  source      = "../../modules/proxmox_vm"
  node_name   = "talos"
  template_id = 9001
  vm_name     = "podman-host"

  # Hardware settings overridden here
  ssh_public_key = var.ssh_public_key
}

output "proxmox_vm_ip" {
  value = module.proxmox_vm.ip_address
}