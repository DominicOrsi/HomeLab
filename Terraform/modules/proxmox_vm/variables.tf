variable "node_name" {
  type = string
}
variable "vm_name" {
  type = string
}
variable "template_id" {
  description = "The VM ID of your template"
  type        = number
}

# VM Hardware
variable "vm_cpu_cores" {
  default = 2
}

variable "vm_memory" {
  default = 2048
}
variable "vm_agent" {
  default = true
}

variable "cpu_type" {
  default = "host"
}

# Disk & Storage
variable "storage_id" {
  default = "local-lvm"
}
variable "disk_size" {
  default = 20
}
variable "disk_interface" {
  default = "scsi0"
}

# Network
variable "network_bridge" {
  default = "vmbr0"
}

# Cloud-Init User
variable "username" {
  default = "ansible"
}
variable "ssh_public_key" {
  type = string
}
