# Container/LXC Module
module "proxmox_lxc" {
  source = "../../modules/proxmox_lxc"
  node_name = "talos"
  hostname = "Traefik"

  ct_id = 101
  template_id = "local:vztmpl/debian-12-standard_12.12-1_amd64.tar.zst"
  operating_system_name = "debian"

  user_password = ""
  ssh_public_key = var.ssh_public_key

}

output "proxmox_lxc_ip" {
  value = module.proxmox_lxc.container_ips
}