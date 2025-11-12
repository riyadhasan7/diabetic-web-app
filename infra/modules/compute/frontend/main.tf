# VM SSH Key for Admin Access
resource "tls_private_key" "ssh" {
  algorithm = "RSA"
  rsa_bits  = 4096
}



# Public IP for Application Gateway
resource "azurerm_public_ip" "appgw_pip" {
  name                = "${var.resource_name_prefix}-appgw-pip"
  resource_group_name = var.resource_group_name
  location            = var.location
  sku                 = "Standard"
  allocation_method   = "Static"
}

# Application geteway
resource "azurerm_application_gateway" "appgw" {
  name                = "${var.resource_name_prefix}-app-gayteway"
  resource_group_name = var.resource_group_name
  location            = var.location
  tags = var.tags

    sku {
        name     = "WAF_v2"
        tier     = "WAF_v2"
        capacity = 2
    }

    gateway_ip_configuration {
        name      = "app-gateway-ip-configuration"
        subnet_id = var.appgw_subnet_id
    }

  frontend_port {
    name = "http-port"
    port = 80
  }

  frontend_ip_configuration {
    name                 = "app-gateway-frontend-ip"
    public_ip_address_id = azurerm_public_ip.appgw_pip.id
  }

  backend_address_pool {
    name = "app-gateway-backend-pool"
  }

  backend_http_settings {
    name                  = "app-gateway-backend-http-settings"
    cookie_based_affinity = "Disabled"
    path                  = "/path1/"
    port                  = 80
    protocol              = "Http"
    request_timeout       = 60
  }

  http_listener {
    name                           = "app-gateway-http-listener"
    frontend_ip_configuration_name = "app-gateway-frontend-ip"
    frontend_port_name             = "http-port"
    protocol                       = "Http"
  }

  request_routing_rule {
    name                       = "app-gateway-request-routing-rule"
    priority                   = 9
    rule_type                  = "Basic"
    http_listener_name         = "app-gateway-http-listener"
    backend_address_pool_name  = "app-gateway-backend-pool"
    backend_http_settings_name = "app-gateway-backend-http-settings"
  }

probe {
    name                = "health-probe"
    host                = "127.0.0.1"
    interval            = 30
    timeout             = 30
    unhealthy_threshold = 3
    protocol            = "Http"
    port                = 80
    path                = "/health"
  }

  waf_configuration {
    enabled          = true
    firewall_mode    = "Prevention"
    rule_set_type    = "OWASP"
    rule_set_version = "3.2"
  }
}

# User-assigned Managed Identity for VM Scale Set
resource "azurerm_user_assigned_identity" "frontend_vmss_identity" {
  name                = "${var.resource_name_prefix}-identity"
  resource_group_name = var.resource_group_name
  location            = var.location
  tags                = var.tags
}



# vm scale set for frontend servers
resource "azurerm_linux_virtual_machine_scale_set" "frontend_vmss" {
  name                = "${var.resource_name_prefix}-frontend-vmss"
  resource_group_name = var.resource_group_name
  location            = var.location
  sku                 = "Standard_D2s_v3"
  instances           = var.frontend_instance_count
  admin_username = "azureuser"

    identity {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.frontend_vmss_identity.id]
  }

  # Prevent direct SSH access, use Bastion instead
  disable_password_authentication = true

  admin_ssh_key {
    username   = "azureuser"
    public_key = tls_private_key.ssh.public_key_openssh
  }



  computer_name_prefix = "frontendvm"
  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  network_interface {
    name    = "frontend-vmss-nic"
    primary = true

    ip_configuration {
      name                                   = "frontend-vmss-ipconfig"
      subnet_id                              = var.subnet_id
      primary                                = true
      application_gateway_backend_address_pool_ids = [ for pool in azurerm_application_gateway.appgw.backend_address_pool : pool.id ]
    }
  }
  
  tags = var.tags
}

# Auto scaling settings
resource "azurerm_monitor_autoscale_setting" "scale_setting" {
  name                = "${var.resource_name_prefix}-auto-scaling-action"
  resource_group_name = var.resource_group_name
  location            = var.location
  target_resource_id  = azurerm_linux_virtual_machine_scale_set.frontend_vmss.id

  profile {
    name = "defaultProfile"

    capacity {
      default = 2
      minimum = 1
      maximum = 10
    }

    rule {
      metric_trigger {
        metric_name        = "Percentage CPU"
        metric_resource_id = azurerm_linux_virtual_machine_scale_set.frontend_vmss.id
        time_grain         = "PT1M"
        statistic          = "Average"
        time_window        = "PT5M"
        time_aggregation   = "Average"
        operator           = "GreaterThan"
        threshold          = 75
        metric_namespace   = "microsoft.compute/virtualmachinescalesets"
        dimensions {
          name     = "AppName"
          operator = "Equals"
          values   = ["App1"]
        }
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
        metric_resource_id = azurerm_linux_virtual_machine_scale_set.frontend_vmss.id
        time_grain         = "PT1M"
        statistic          = "Average"
        time_window        = "PT5M"
        time_aggregation   = "Average"
        operator           = "LessThan"
        threshold          = 25
      }

      scale_action {
        direction = "Decrease"
        type      = "ChangeCount"
        value     = "1"
        cooldown  = "PT1M"
      }
    }
  }
}
