variable "node_name" {
  type = string
  description = "Proxmox Host"
}

variable "ct_id" {
  type = number
  description = "Container ID"
}

variable "description" {
  type = string
  description = "Description of LXC"
  default = "Terraform Created LXC"
}

# CPU Info
variable "architecture" {
  type = string
  description = "CPU Architecture"
  default = "amd64"
}

variable "cpu_cores" {
  type = number
  description = "Number of CPU Cores"
  default = 1
}

# Disk
variable "storage_id" {
  type    = string
  description = "Identifier for the data store to creak the disk in"
  default = "local-lvm"
}

variable "disk_size" {
  type    = number
  description = "Size of the root filesystem in GB"
  default = 4
}

# Initialization
variable "hostname" {
  type        = string
  description = "Hostname of LXC"
}

variable "ip_config_ipv4_address" {
  type = string
  default = "dhcp"
}

variable "ssh_public_key" {
  type        = string
  description = "Your public SSH key for container access"
}

variable "user_password" {
  type = string
  description = "Password for root account"
  sensitive = true
}

# Memory
variable "dedicated" {
  type = number
  description = "Dedicated memory in MB"
  default = 512
}

# Network
variable "bridge" {
  type = string
  description = "Network bridge"
  default = "vmbr0"
}

variable "network_interface_name" {
  type = string
  description = "Network interface name"
  default = "eth0"
}

# Operating System
variable "template_id" {
  type        = string
  description = "The full path to the LXC template (e.g., local:vztmpl/fedora...)"
  default     = "local:vztmpl/fedora-43-default_20260115_amd64.tar.xz"
}

variable "operating_system_name" {
  type        = string
  description = "Name of the OS"
  default     = "fedora"
}