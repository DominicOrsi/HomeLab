terraform {
  required_version = ">= 1.14.0"

  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = ">= 0.95.0"
    }
  }
}

provider "proxmox" {
  username = var.proxmox_user
  password = var.proxmox_password
  endpoint  = var.proxmox_endpoint
  # api_token = var.proxmox_api_token
  insecure = true
}
