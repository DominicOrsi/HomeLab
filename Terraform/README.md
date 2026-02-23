# 🏗️ Terraform Infrastructure

This directory contains the Infrastructure-as-Code (IaC) used to provision Virtual Machines and Containers on **Proxmox VE**.

## 📁 Directory Structure

The repository is organized using a **Modular Architecture** to separate reusable logic from environment-specific configuration:

* **`modules/`**: Contains the blueprints for infrastructure (LXC and VM). These are generic and highly customizable.
* **`environments/`**: Contains the "Live" state. This is where modules are called and specific resources (like my Traefik VM) are defined.

## 🛠️ Requirements

| Tool | Version |
| :--- | :--- |
| [Terraform](https://www.terraform.io/downloads.html) | `1.14.0+` |
| [Proxmox Provider](https://registry.terraform.io/providers/bpg/proxmox/latest) | `0.95.0+` |
| Proxmox VE | `8.x` Recommended |

## 🚀 Getting Started

### 1. Prepare your environment
Navigate to the homelab environment:
```bash
cd environments/homelab

```

### 2. Configure Variables

Copy the example variables file and fill in your Proxmox API credentials and SSH keys:

```bash
cp terraform.tfvars.example terraform.tfvars
# Edit terraform.tfvars with your actual values

```

### 3. Initialize & Apply

```bash
terraform init     # Downloads providers and initializes modules
terraform plan     # Preview the changes
terraform apply    # Deploy the infrastructure

```

## 🔒 Security Best Practices

* **State Files:** Local `.tfstate` files are excluded via `.gitignore` as they may contain sensitive data.
* **Secrets:** Never commit `terraform.tfvars`. Use the provided `.example` files as a template.
* **Sensitive Vars:** Variables like `user_password` are marked as `sensitive` to prevent them from appearing in CLI logs.

## 📡 Output to Ansible

Once the infrastructure is applied, Terraform provides the IP addresses of the created instances. These IPs are then used as inputs for our **Ansible** playbooks to handle software configuration.

---

**Next Step:** Once the VMs are up, head over to the [Ansible directory](../Ansible/README.md) to begin software deployment.
