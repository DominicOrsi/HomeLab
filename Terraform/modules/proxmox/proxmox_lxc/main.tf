
resource "proxmox_virtual_environment_container" "lxc_container" {
  node_name = var.node_name # from external main
  vm_id     = var.ct_id # from external main

  description = var.description

  cpu {
    architecture = var.architecture
    cores = var.cpu_cores
  }

  disk {
    datastore_id = var.storage_id
    size = var.disk_size
  }

  initialization {
    hostname = var.hostname # from external main

    ip_config {
      ipv4 {
        address = var.ip_config_ipv4_address
      }
    }

    user_account {
      keys = [var.ssh_public_key] # from external main
      password = var.user_password # from external main
    }
  }

  memory {
    dedicated = var.dedicated
  }

  network_interface {
    name   = var.network_interface_name
    bridge = var.bridge
  }

  operating_system {
    template_file_id = var.template_id
    type             = var.operating_system_name
  }

}