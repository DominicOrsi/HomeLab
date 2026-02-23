# 🚦 Traefik Role

This role installs and configures **Traefik v3** as a high-performance edge router. It features fully automated SSL management via Cloudflare DNS challenges and dynamic routing for Proxmox hosts and SSH services.

## ✨ Advanced Features

* **Dynamic Inventory Integration:** Automatically generates Traefik entry points and routers by looping through your Ansible inventory groups.
* **Automatic SSL:** Integrated with Let's Encrypt and Cloudflare DNS-01 challenges for wildcard certificates (`*.dino.computer`).
* **SSH-over-TCP:** Leverages Traefik TCP routers to proxy SSH traffic to internal nodes on specific high-ports.
* **Security Hardened:** * Dashboard protected by Basic Auth.
    * IP Allow-listing for internal management networks.
    * Forced HTTPS redirection and TLS 1.3 configuration.

## 📁 Directory Structure

* **`tasks/main.yml`**: Binary installation, systemd setup, and directory provisioning.
* **`templates/traefik.yaml.j2`**: The static configuration (EntryPoints, Providers, Certificates).
* **`templates/proxmox.yaml.j2`**: Dynamic HTTP routing for the Proxmox UI.
* **`templates/ssh_generic.yaml.j2`**: Dynamic TCP routing for SSH access.
* **`handlers/main.yml`**: Managed service restarts and systemd reloads.

## 🔧 Required Variables

These should be defined in your `inventory/group_vars/all/vault.yml`:

| Variable | Description |
| :--- | :--- |
| `traefik_version` | Version string (e.g., `3.6.8`). |
| `cf_dns_api_token` | Cloudflare API Token with DNS Edit permissions. |
| `acme_email` | Email address for Let's Encrypt registration. |
| `traefik_dashboard_user_auth` | Basic Auth string for the dashboard (generated via `htpasswd`). |

### Dynamic Inventory Variables
To trigger the automatic proxying of a host, define these in your host/group vars:
* `ssh_proxy_port`: The external port Traefik should listen on to route to that host's port 22.

## 🚀 How it Works

1. **Binary Install:** Downloads the official Linux amd64 binary directly from GitHub.
2. **Persistence:** Creates `acme.json` with `0600` permissions to store certificates securely.
3. **Inventory Loop:** The `traefik.yaml.j2` template loops through `groups['all']`. If a host has `ssh_proxy_port` defined, Traefik automatically creates a TCP entrypoint and router for it.
4. **Proxmox Routing:** The `proxmox.yaml.j2` template detects all hosts in the `proxmox_hosts` group and creates a `https://host.dino.computer` route pointing to their web UI.

---
**Note:** Ensure your firewall/router forwards ports 80, 443, and your custom SSH ports to the Traefik host.
