output "lb_name" {
  value = azurerm_lb.this.name
}

output "backend_address_pool" {
  value = azurerm_lb_backend_address_pool.this.id
}