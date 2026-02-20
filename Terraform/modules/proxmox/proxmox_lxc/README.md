# Proxmox LXC Container Module

This module automates the creation and configuration of Linux Containers (LXC) on Proxmox VE using the `bpg/proxmox` provider. It includes support for automated networking, disk provisioning, and SSH key injection.

## Features

* **Template-Based Deployment:** Quickly spin up containers from `.tar.xz` templates.
* **Flexible Resource Allocation:** Easily customize CPU cores, Architecture, and RAM.
* **Automated Provisioning:** Handles hostname setup, root password, and SSH key injection via the `initialization` block.
* **Network Ready:** Defaults to `dhcp` on `eth0` via `vmbr0`, but fully customizable.

## Prerequisites

1. **LXC Template:** Ensure you have an LXC template downloaded to your Proxmox storage (e.g., `local:vztmpl/fedora-43...`).
2. **Unprivileged vs Privileged:** By default, the provider handles unprivileged containers. Ensure your storage backend supports the desired container type.

---

## Usage

Add the following to your root `main.tf`:

```hcl
module "my_container" {
  source      = "./modules/proxmox_lxc"
  node_name   = "pve"
  ct_id       = 201
  hostname    = "fedora-app-01"

  # OS Template details
  template_id           = "local:vztmpl/fedora-43-default_20260115_amd64.tar.xz"
  operating_system_name = "fedora"

  # User Configuration
  user_password  = var.ct_root_password # Passed from sensitive tfvars
  ssh_public_key = var.ssh_public_key

  # Resources
  cpu_cores = 1
  dedicated = 1024
  disk_size = 8
}

```

---

## Inputs

| Name | Description | Type | Default |
| --- | --- | --- | --- |
| `node_name` | The Proxmox host node. | `string` | **Required** |
| `ct_id` | The unique ID for the container. | `number` | **Required** |
| `hostname` | The hostname for the container. | `string` | **Required** |
| `user_password` | Password for the root account. | `string` | **Required** |
| `ssh_public_key` | Public SSH key for container access. | `string` | **Required** |
| `template_id` | Path to the LXC template (e.g. `local:vztmpl/...`). | `string` | `local:vztmpl/fedora...` |
| `operating_system_name` | OS type (e.g. `fedora`, `ubuntu`, `debian`). | `string` | `fedora` |
| `cpu_cores` | Number of CPU cores. | `number` | `1` |
| `architecture` | CPU Architecture (`amd64`, `arm64`). | `string` | `amd64` |
| `dedicated` | Dedicated RAM in MB. | `number` | `512` |
| `storage_id` | Target datastore for the disk. | `string` | `local-lvm` |
| `disk_size` | Size of the root filesystem in GB. | `number` | `4` |
| `ip_config_ipv4_address` | IPv4 address (format: `192.168.1.5/24` or `dhcp`). | `string` | `dhcp` |
| `bridge` | Network bridge to attach to. | `string` | `vmbr0` |
| `description` | Notes/Description for the Proxmox UI. | `string` | `Terraform Created LXC` |

---

## Outputs

| Name | Description |
| --- | --- |
| `container_id` | The VMID assigned to the container. |
| `container_ips` | The assigned IPv4 addresses of the container. |

---

## Technical Details

* **Provider:** `bpg/proxmox` version `0.95.0+`
* **Terraform Version:** `1.14.0+`
* **Default Interface:** `eth0` using the `virtio` model (implicit).

## Implementation Notes

> [!TIP]
> Since Containers do not use the QEMU Guest Agent like VMs, the IP address is typically reported directly by the Proxmox API via the `initialization` results. If you use DHCP, ensure your network allows LXC containers to request leases through the bridge.
