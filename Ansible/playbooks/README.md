# 📖 Playbook Catalog

This directory contains the entry points for configuring the homelab.

## 🏗️ Core Playbooks

### 👤 `create_users.yml`
**Purpose:** Bootstraps new LXCs/VMs by creating a management user and securing SSH.
* **Key Variables:** `ansible_user_name`, `ansible_ssh_pub_key`.
* **Security:** Hardens SSH by prohibiting root password login and setting up passwordless sudo.

### 💻 `deploy_proxmox.yml`
**Purpose:** Configures the Proxmox Hypervisor.
* **Logic:** Uses `include_role` for the `proxmox_host` role.
* **Target Group:** `proxmox_hosts`.

### 🚦 `deploy_traefik.yml`
**Purpose:** Installs and configures Traefik v3.x.
* **Logic:** Executes the `traefik` role.
* **Target Group:** `traefik_nodes`.

### 🟢 `test_connection.yml`
**Purpose:** A diagnostic tool to verify that your inventory is reachable.
* **Tip:** Run this first whenever you add a new node to your Proxmox cluster.

---

## 🛠️ Running the Automation

### The "New Node" Workflow
After Terraform creates a node, run this sequence:

1. **Test Connectivity:**
```bash
   ansible-playbook playbooks/test_connection.yml
```

2. **Bootstrap Users:**
```bash
ansible-playbook playbooks/create_users.yml --ask-become-pass
```

3. **Deploy Services:**
```bash
ansible-playbook playbooks/deploy_traefik.yml --ask-vault-pass
```
---

**Note:** Many variables are pulled from `inventory/group_vars/all/all.yml`. Ensure these are populated before running.
