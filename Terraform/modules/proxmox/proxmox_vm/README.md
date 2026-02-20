# Proxmox VM Terraform Module

This module automates the deployment of Virtual Machines on **Proxmox VE** using the `bpg/proxmox` provider. It is designed to work with **Cloud-Init** templates, automatically configuring networking via DHCP and setting up a management user with SSH access.

## Features

* **Template Cloning:** Rapidly deploys VMs from a pre-configured "Golden Image" (Template).
* **Cloud-Init Integration:** Automatically injects usernames and SSH keys.
* **DHCP Networking:** Default configuration handles IP assignment via your network's DHCP server.
* **Guest Agent Support:** Required for reporting IP addresses back to Terraform for Ansible integration.

## Prerequisites

1. **Proxmox Template:** A VM converted to a template with `qemu-guest-agent` and `cloud-init` installed.
2. **API Token:** A Proxmox API token with sufficient permissions to create and manage VMs.
3. **SSH Key:** A public SSH key for the `initialization` block.

---

## Usage

Add the following block to your root `main.tf`:

```hcl
module "my_vm" {
  source      = "./modules/proxmox_vm"
  node_name   = "pve"
  template_id = 9000
  vm_name     = "app-server-01"

  # Resource Customization
  vm_cpu_cores = 4
  vm_memory    = 4096
  disk_size    = 50
  storage_id   = "local-lvm"

  # User Configuration
  username       = "ansible"
  ssh_public_key = var.ssh_public_key
}

```

---

## Inputs

| Name | Description | Type | Default |
| --- | --- | --- | --- |
| `node_name` | The Proxmox node where the VM will be created. | `string` | **Required** |
| `vm_name` | The name of the virtual machine. | `string` | **Required** |
| `template_id` | The VM ID of the source template to clone. | `number` | **Required** |
| `ssh_public_key` | The public SSH key for the Cloud-Init user. | `string` | **Required** |
| `vm_cpu_cores` | Number of CPU cores. | `number` | `2` |
| `cpu_type` | The CPU type (e.g., `host` for best performance). | `string` | `host` |
| `vm_memory` | Dedicated RAM in MB. | `number` | `2048` |
| `vm_agent` | Enable/Disable QEMU Guest Agent. | `bool` | `true` |
| `storage_id` | The target datastore for the VM disk. | `string` | `local-lvm` |
| `disk_size` | Size of the disk in GB. | `number` | `20` |
| `network_bridge` | The Proxmox network bridge (e.g., `vmbr0`). | `string` | `vmbr0` |
| `username` | The username created by Cloud-Init. | `string` | `ansible` |

---

## Outputs

| Name | Description |
| --- | --- |
| `vm_id` | The assigned ID of the new VM. |
| `vm_name` | The name of the VM instance. |
| `ip_address` | The primary IPv4 address (retrieved from Guest Agent). |
| `all_ips` | A full list of all IP addresses assigned to the VM. |

---

## Technical Details

* **Provider:** `bpg/proxmox` version `0.95.0+`
* **Terraform Version:** `1.14.0+`
* **Disk Interface:** Defaulted to `scsi0` for performance.
* **Network Model:** Configured via bridge settings for transparent LAN access.

## Implementation Notes

> [!IMPORTANT]
> To ensure the `ip_address` output works correctly, ensure `qemu-guest-agent` is enabled in your template and that the `vm_agent` variable is set to `true`. Terraform may take a moment after boot to display the IP.