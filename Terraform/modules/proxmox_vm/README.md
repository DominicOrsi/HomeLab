# Proxmox VM Terraform Module

This module automates the deployment of Virtual Machines on **Proxmox VE** using the `bpg/proxmox` provider. It is optimized for a **Cloud-Init** workflow, enabling rapid cloning from "Golden Images."

## 🚀 Features

* **Template Cloning:** Performs full clones of existing VM templates for maximum performance and stability.
* **Cloud-Init Orchestration:** Injects user credentials and SSH keys automatically during provisioning.
* **Dynamic Resource Scaling:** Easily override CPU, Memory, and Disk sizes per instance.
* **Ansible Ready:** Outputs guest IP addresses retrieved directly from the QEMU Guest Agent.

## 📦 Usage

Reference this module in your environment configuration (e.g., `environments/homelab/main.tf`):

```hcl
module "worker_node" {
  source      = "../../modules/proxmox_vm"

  node_name   = "pve"
  template_id = 9000  # Your Golden Image ID
  vm_name     = "app-server-01"

  # Resource Customization
  vm_cpu_cores = 4
  vm_memory    = 4096
  disk_size    = 50
  storage_id   = "local-zfs"

  # Cloud-Init Configuration
  username       = "ansible"
  ssh_public_key = var.ssh_public_key
}

```

---

## 🔧 Inputs

| Name | Description | Type | Default |
| --- | --- | --- | --- |
| `node_name` | The Proxmox node where the VM will be created. | `string` | **Required** |
| `vm_name` | The name of the virtual machine. | `string` | **Required** |
| `template_id` | The VM ID of the source template to clone. | `number` | **Required** |
| `ssh_public_key` | The public SSH key for the Cloud-Init user. | `string` | **Required** |
| `username` | The username created by Cloud-Init. | `string` | `ansible` |
| `vm_cpu_cores` | Number of CPU cores. | `number` | `2` |
| `cpu_type` | CPU type (use `host` for best performance). | `string` | `host` |
| `vm_memory` | Dedicated RAM in MB. | `number` | `2048` |
| `vm_agent` | Enable/Disable QEMU Guest Agent. | `bool` | `true` |
| `storage_id` | Target datastore for the VM disk. | `string` | `local-lvm` |
| `disk_size` | Size of the disk in GB. | `number` | `20` |
| `disk_interface` | Bus/Interface for the disk. | `string` | `scsi0` |
| `network_bridge` | Proxmox bridge (e.g., `vmbr0`). | `string` | `vmbr0` |

---

## 📤 Outputs

| Name | Description |
| --- | --- |
| `vm_id` | The assigned ID of the new VM. |
| `vm_name` | The name of the VM instance. |
| `ip_address` | The primary IPv4 address (index [1][0] from Guest Agent). |
| `all_ips` | Full map of all assigned IP addresses. |

---

## 🛠 Technical Details

* **Cloning:** Uses `full = true` to ensure the new VM is independent of the template.
* **Agent:** Requires `qemu-guest-agent` installed in the template for IP reporting.
* **Network:** Defaults to DHCP via the specified bridge.

> [!TIP]
> **Wait for IP:** When running `terraform apply`, the IP address output might be blank for the first 30–60 seconds while the VM boots and the Guest Agent starts. This is normal behavior for Cloud-Init deployments.
