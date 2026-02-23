# Proxmox LXC Container Module

This module automates the creation and configuration of Linux Containers (LXC) on Proxmox VE using the `bpg/proxmox` provider.

## 🚀 Features

* **Modular Design:** Easily called from environment-specific configurations.
* **Template-Based Deployment:** Supports standard `.tar.xz` templates.
* **Security Focused:** Uses sensitive variable handling for root passwords.
* **Automated Provisioning:** Injects SSH keys and sets up networking (DHCP or Static) during the first boot.

## 📦 Usage

To use this module in your environment (e.g., `environments/homelab/main.tf`), reference it as follows:

```hcl
module "my_container" {
  source      = "../../modules/proxmox_lxc"

  node_name   = "pve"
  ct_id       = 201
  hostname    = "fedora-app-01"

  # OS Template details
  template_id           = "local:vztmpl/fedora-43-default_20260115_amd64.tar.xz"
  operating_system_name = "fedora"

  # User Configuration (Use variables from terraform.tfvars)
  user_password  = var.ct_root_password
  ssh_public_key = var.ssh_public_key

  # Resources
  cpu_cores = 1
  dedicated = 1024
  disk_size = 8
}

```

---

## 🔧 Inputs

| Name | Description | Type | Default |
| --- | --- | --- | --- |
| `node_name` | The Proxmox host node. | `string` | **Required** |
| `ct_id` | The unique ID for the container. | `number` | **Required** |
| `hostname` | The hostname for the container. | `string` | **Required** |
| `user_password` | Password for the root account (Marked as Sensitive). | `string` | **Required** |
| `ssh_public_key` | Public SSH key for container access. | `string` | **Required** |
| `template_id` | Path to the LXC template (e.g. `local:vztmpl/...`). | `string` | `local:vztmpl/fedora...` |
| `operating_system_name` | OS type (e.g. `fedora`, `ubuntu`, `debian`). | `string` | `fedora` |
| `cpu_cores` | Number of CPU cores. | `number` | `1` |
| `dedicated` | Dedicated RAM in MB. | `number` | `512` |
| `storage_id` | Target datastore for the disk. | `string` | `local-lvm` |
| `disk_size` | Size of the root filesystem in GB. | `number` | `4` |
| `ip_config_ipv4_address` | IPv4 address (format: `192.168.1.5/24` or `dhcp`). | `string` | `dhcp` |
| `unprivileged` | Whether the container is unprivileged. | `bool` | `true` |

---

## 📤 Outputs

| Name | Description |
| --- | --- |
| `container_id` | The VMID assigned to the container. |
| `container_ips` | The assigned IPv4 addresses of the container. |

---

## 🛠 Technical Details

* **Provider:** `bpg/proxmox` version `0.95.0+`
* **Terraform Version:** `1.14.0+`
* **Resource Type:** `proxmox_virtual_environment_container`

> [!IMPORTANT]
> **Security Note:** The `user_password` variable is marked as `sensitive = true`. While this hides it from the CLI output, remember that it is still stored in plain text within your `terraform.tfstate` file. Ensure your state file is excluded from version control (checked in `.gitignore`).
