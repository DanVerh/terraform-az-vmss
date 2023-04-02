resource "azurerm_linux_virtual_machine_scale_set" "this" {
  name                = var.vmss_name
  location            = var.location
  resource_group_name = var.rg_name
  instances = 2
  sku = "Standard_F2"
  disable_password_authentication = false
  admin_username       = var.admin_name
  admin_password       = var.admin_password

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }

  os_disk {
    storage_account_type = "Standard_LRS"
    caching              = "ReadWrite"
  }

  network_interface {
    name    = "networkinterface"
    primary = true
    network_security_group_id              = var.sg_id

    ip_configuration {
      name                                   = "IPConfiguration"
      primary                                = true
      subnet_id                              = var.subnet_id
      load_balancer_backend_address_pool_ids = [var.backend_address_pool]
      
    }
  }

  connection {
    type        = "ssh"
    host        = var.pip
    user        = var.admin_name
    password    = var.admin_password
    timeout     = "2m"
  }

  provisioner "file" {
    source      = "script/provisioner.sh"
    destination = "provisioner.sh"
  }

  provisioner "remote-exec"{
    inline = [
      "chmod +x provisioner.sh",
      "./provisioner.sh"
    ]
  }
}

resource "azurerm_monitor_autoscale_setting" "this" {
  name                = "myAutoscaleSetting"
  resource_group_name = var.rg_name
  location            = var.location
  target_resource_id  = azurerm_linux_virtual_machine_scale_set.this.id

  profile {
    name = "metricProfile"

    capacity {
      default = var.default
      minimum = var.min
      maximum = var.max
    }

    rule {
      metric_trigger {
        metric_name        = "Percentage CPU"
        metric_resource_id = azurerm_linux_virtual_machine_scale_set.this.id
        time_grain         = "PT1M"
        statistic          = "Average"
        time_window        = "PT10M"
        time_aggregation   = "Average"
        operator           = "GreaterThan"
        threshold          = 70
        metric_namespace   = "microsoft.compute/virtualmachinescalesets"
      }

      scale_action {
        direction = "Increase"
        type      = "ChangeCount"
        value     = "1"
        cooldown  = "PT1M"
      }
    }

    rule {
      metric_trigger {
        metric_name        = "Percentage CPU"
        metric_resource_id = azurerm_linux_virtual_machine_scale_set.this.id
        time_grain         = "PT1M"
        statistic          = "Average"
        time_window        = "PT10M"
        time_aggregation   = "Average"
        operator           = "LessThan"
        threshold          = 30
      }

      scale_action {
        direction = "Decrease"
        type      = "ChangeCount"
        value     = "1"
        cooldown  = "PT1M"
      }
    }
  }

  profile {
    name = "scheduleProfile"

    capacity {
      default = var.default
      minimum = var.min
      maximum = var.max
    }

    rule{
       metric_trigger {
        metric_name        = "Percentage CPU"
        metric_resource_id = azurerm_linux_virtual_machine_scale_set.this.id
        time_grain         = "PT1M"
        statistic          = "Average"
        time_window        = "PT10M"
        time_aggregation   = "Average"
        operator           = "GreaterThan"
        threshold          = 70
        metric_namespace   = "microsoft.compute/virtualmachinescalesets"
      }

      scale_action {
        direction = "Increase"
        type      = "ExactCount"
        value     = "5"
        cooldown  = "PT1M"
      }

     
    }
     recurrence {
        timezone = "E. Europe Standard Time"
        days     = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday"]
        hours    = [9]
        minutes  = [0]
      }
  }

  profile {
    name = "decreaseTo3Profile"

        capacity {
          default = var.default
          minimum = var.min
          maximum = var.max
        }
    rule{
      metric_trigger {
        metric_name        = "Percentage CPU"
        metric_resource_id = azurerm_linux_virtual_machine_scale_set.this.id
        time_grain         = "PT1M"
        statistic          = "Average"
        time_window        = "PT10M"
        time_aggregation   = "Average"
        operator           = "LessThan"
        threshold          = 30
      }

      scale_action {
        direction = "Decrease"
        type      = "ExactCount"
        value     = "2"
        cooldown  = "PT1M"
      }

     
  }
  recurrence {
      timezone = "E. Europe Standard Time"
      days     = ["Saturday", "Sunday"]
      hours    = [18]
      minutes  = [0]
  }
  }

}