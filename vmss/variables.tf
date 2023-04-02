variable "rg_name" {
  description = "Resource group name"
}

variable "location" {
  description = "Resource group location"
}

variable "vmss_name" {
  description = "Virtual Machine Scale Set name"
}

variable "subnet_id" {
  description = "Subnet ID"
}

variable "admin_name" {
  description = "Admin name"
}

variable "admin_password" {
  description = "Admin password"
}

variable "max" {
  description = "Max instances"
}

variable "min" {
  description = "Min instances"
}

variable "default" {
  description = "Default number of instances"
}

variable "backend_address_pool" {
  description = "LB backend address pool"
}

variable "pip" {
  description = "Frontend IP address for LB"
}

variable "sg_id" {
  description = "SG ID for VMSS"
}