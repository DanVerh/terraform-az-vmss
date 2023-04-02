resource "azurerm_virtual_network" "this" {
  name                = var.vnet_name
  address_space       = [var.vnet_address]
  location            = var.location
  resource_group_name = var.rg_name
}

resource "azurerm_subnet" "this" {
  name                 = var.subnet_name
  resource_group_name  = var.rg_name
  virtual_network_name = azurerm_virtual_network.this.name
  address_prefixes     = [var.subnet_address]
}

resource "azurerm_public_ip" "this" {
  name                = var.pip_name
  location            = var.location
  resource_group_name = var.rg_name
  allocation_method   = "Static"
  domain_name_label   = var.pip_name
}

resource "azurerm_network_security_group" "this" {
  name                = "vmss-sg"
  location            = var.location
  resource_group_name = var.rg_name
}

resource "azurerm_network_security_rule" "this" {
  name                        = "ssh-vmss"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "22"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = var.rg_name
  network_security_group_name = azurerm_network_security_group.this.name
}