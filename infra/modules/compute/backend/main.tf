# VM SSH Key for Admin Access
resource "tls_private_key" "ssh" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "azurerm_lb" "lb" {
  name                = "${var.resource_name_prefix}-lb"
  resource_group_name = var.resource_group_name
  location            = var.location
  tags                = var.tags
  sku                 = "Standard"

  frontend_ip_configuration {
    name                 = "lb-frontend-ip"
    subnet_id            = var.subnet_id
    private_ip_address_allocation = "Dynamic"
  }
}

# Create a Backend Address Pool for the Load Balancer
resource "azurerm_lb_backend_address_pool" "lb-bepool" {
  loadbalancer_id = azurerm_lb.lb.id
  name            = "${var.resource_name_prefix}-pool"
}

# Create a Load Balancer Probe to check the health of the 
# Virtual Machines in the Backend Pool
resource "azurerm_lb_probe" "probe" {
  loadbalancer_id = azurerm_lb.lb.id
  name            = "${var.resource_name_prefix}-probe"
  port            = 80
  
}

# Create a Load Balancer Rule to define how traffic will be
# distributed to the Virtual Machines in the Backend Pool
resource "azurerm_lb_rule" "lb-rule" {
  loadbalancer_id                = azurerm_lb.lb.id
  name                           = "${var.resource_name_prefix}-rule"
  protocol                       = "Tcp"
  frontend_port                  = 80
  backend_port                   = 80
  disable_outbound_snat          = true
  frontend_ip_configuration_name = "lb-frontend-ip"
  probe_id                       = azurerm_lb_probe.probe.id
  backend_address_pool_ids       = [azurerm_lb_backend_address_pool.lb-bepool.id]
}

# User-assigned Managed Identity for VM Scale Set
resource "azurerm_user_assigned_identity" "backend_vmss_identity" {
  name                = "${var.resource_name_prefix}-identity"
  resource_group_name = var.resource_group_name
  location            = var.location
  tags                = var.tags
}
  

# vm scale set for frontend servers
resource "azurerm_linux_virtual_machine_scale_set" "backend_vmss" {
  name                = "${var.resource_name_prefix}-backend_vmss"
  resource_group_name = var.resource_group_name
  location            = var.location
  sku                 = "Standard_D2s_v3"
  instances           = var.backend_instance_count
  admin_username = "azureuser"

    identity {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.backend_vmss_identity.id]
  }

    # Prevent direct SSH access, use Bastion instead
  disable_password_authentication = true

  admin_ssh_key {
    username   = "azureuser"
    public_key = tls_private_key.ssh.public_key_openssh
  }

  computer_name_prefix = "backendvm"
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
      load_balancer_backend_address_pool_ids = [azurerm_lb_backend_address_pool.lb-bepool.id]

    }
  }
  
  tags = var.tags
}

# Auto scaling settings
resource "azurerm_monitor_autoscale_setting" "scale_setting" {
  name                = "${var.resource_name_prefix}-auto-scaling-action ${var.environment}"
  resource_group_name = var.resource_group_name
  location            = var.location 
  target_resource_id  = azurerm_linux_virtual_machine_scale_set.backend_vmss.id

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
        metric_resource_id = azurerm_linux_virtual_machine_scale_set.backend_vmss.id
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
        metric_resource_id = azurerm_linux_virtual_machine_scale_set.backend_vmss.id
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