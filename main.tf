provider "azurerm" {
  features {}
}

module "rg" {
  source = "./rg"

  rg_name = "vmss"
  rg_location = "East US"
}

module "network" {
  source = "./networking"

  rg_name = module.rg.rg_name
  location = module.rg.rg_location 
  vnet_name = "vnet"
  vnet_address = "10.0.0.0/21"
  subnet_name = "subnet1"
  subnet_address = "10.0.0.0/24"
  pip_name = "pipdanverh"
}

module "lb" {
  source = "./lb"

  location = module.rg.rg_location
  rg_name = module.rg.rg_name
  pip_id = module.network.pip_id 
  lb_name = "lb"
  frontend_port = 80
  backend_port = 3000
}

data "azurerm_key_vault" "this" {
  name                = "danverh"
  resource_group_name = "test"
}

data "azurerm_key_vault_secret" "this" {
  name         = "vmss-password"
  key_vault_id = data.azurerm_key_vault.this.id
}

module "vmss" {
  source = "./vmss"

  backend_address_pool = module.lb.backend_address_pool
  location = module.rg.rg_location
  rg_name = module.rg.rg_name
  subnet_id = module.network.subnet_id 
  vmss_name = "vmss"
  admin_name = "danverh"
  admin_password = data.azurerm_key_vault_secret.this.value
  max = 5
  min = 2
  default = 2
}

output "app_public_ip" {
  value = "Public IP of the app: ${module.network.pip_ip}"
}