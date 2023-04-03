resource "azurerm_lb" "this" {
  name                = var.lb_name
  location            = var.location
  resource_group_name = var.rg_name

  frontend_ip_configuration {
    name                 = "PublicIPAddress"
    public_ip_address_id = var.pip_id
  }
}

resource "azurerm_lb_backend_address_pool" "this" {
  loadbalancer_id = azurerm_lb.this.id
  name            = "BackEndAddressPool"
}

resource "azurerm_lb_probe" "this" {
  loadbalancer_id = azurerm_lb.this.id
  name            = "http-probe"
  protocol        = "Http"
  request_path    = "/health"
  port            = 80
}

resource "azurerm_lb_rule" "this" {
  loadbalancer_id                = azurerm_lb.this.id
  name                           = "http"
  protocol                       = "Tcp"
  frontend_port                  = var.app_frontend_port
  backend_port                   = var.app_backend_port
  backend_address_pool_ids       = [azurerm_lb_backend_address_pool.this.id]
  frontend_ip_configuration_name = "PublicIPAddress"
  probe_id                       = azurerm_lb_probe.this.id
}

resource "azurerm_lb_nat_pool" "this" {
  name                           = "ssh"
  resource_group_name            = var.rg_name
  loadbalancer_id                = azurerm_lb.this.id
  protocol                       = "Tcp"
  frontend_port_start            = 50000
  frontend_port_end              = 50119
  backend_port                   = 22
  frontend_ip_configuration_name = "PublicIPAddress"
}