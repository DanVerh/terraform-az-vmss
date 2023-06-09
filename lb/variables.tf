variable "rg_name" {
  description = "Resource group name"
}

variable "location" {
  description = "Resource group location"
}

variable "pip_id" {
  description = "Public IP ID"
}

variable "lb_name" {
  description = "Load balancer name"
}

variable "frontend_port" {
  description = "Frontend LB port"
}

variable "backend_port" {
  description = "Backend LB port"
}