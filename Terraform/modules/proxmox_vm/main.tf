resource "proxmox_virtual_environment_vm" "vm_instance" {
  name      = var.vm_name
  node_name = var.node_name

  clone {
    vm_id = var.template_id
    full  = true
  }

  agent { enabled = var.vm_agent }
  cpu {
    cores = var.vm_cpu_cores
    type = var.cpu_type
    }
  memory { dedicated = var.vm_memory }

  disk {
    datastore_id = var.storage_id
    size         = var.disk_size
    interface    = var.disk_interface
  }

  network_device {
    bridge = var.network_bridge
  }

  initialization {
    ip_config {
      ipv4 { address = "dhcp" }
    }
    user_account {
      username = var.username
      keys     = [var.ssh_public_key]
    }
  }
}
