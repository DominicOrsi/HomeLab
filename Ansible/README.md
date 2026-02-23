# 🛠️ Ansible Configuration

This directory contains the automation needed to configure and maintain my homelab services once the infrastructure has been provisioned by Terraform.

## 📁 Structure Overview

* **`inventory/`**: Defines the hosts and groups. Uses `group_vars` for environment-specific configuration and `vault.yml` for secrets.
* **`roles/`**: Reusable units of automation:
    * `common`: Base system hardening, SSH keys, and package updates.
    * `proxmox_host`: Specific tuning for the hypervisor and Nginx proxy setups.
    * `traefik`: Deployment and configuration of the Traefik Edge Router.
* **`playbooks/`**: Entry-point files that map roles to hosts (e.g., `deploy_traefik.yml`).

## 🚀 Getting Started

### 1. Install Requirements
Install the necessary Ansible collections from Galaxy:
```bash
ansible-galaxy install -r requirements.yml

```

### 2. Prepare Secrets

This project uses **Ansible Vault** to protect sensitive data (API keys, passwords).
If you are forking this, create your own vault or use the `vault.yml.example` provided:

```bash
ansible-vault create inventory/group_vars/all/vault.yml

```

### 3. Run a Playbook

To deploy a specific service, run the associated playbook:

```bash
# Test connection to all hosts
ansible-playbook -i inventory/hosts.ini playbooks/test_connection.yml

# Fully deploy Traefik
ansible-playbook -i inventory/hosts.ini playbooks/deploy_traefik.yml --ask-vault-pass

```

## 🔒 Security Configuration

* **`ansible.cfg`**: Configured to use a dedicated management user and optimized SSH settings.
* **Vault**: Ensure you never commit plain-text passwords. Use `--ask-vault-pass` or a `.vault_pass` file (which is gitignored).
* **SSH Keys**: The `common` role handles the distribution of public keys for passwordless management.

## 📝 Playbook Descriptions

| Playbook | Description |
| --- | --- |
| `test_connection.yml` | Validates SSH connectivity and sudo access across the inventory. |
| `create_users.yml` | Standardizes user accounts and permissions across all nodes. |
| `deploy_proxmox.yml` | Configures the PVE host, creates the Terraform user, and sets up the local proxy. |
| `deploy_traefik.yml` | Installs Traefik, sets up systemd services, and applies dynamic configurations. |

---

**Back to Infrastructure:** Need to provision more nodes? [Check out the Terraform setup](../Terraform/README.md)
