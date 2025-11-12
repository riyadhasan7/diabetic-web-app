resource "azurerm_key_vault" "kv" {
  name                        = "diabetic-app-key-vault"
  location                    = var.location
  resource_group_name         = var.resource_group_name
  tenant_id                   = var.tenant_id
  sku_name                    = "standard"
  soft_delete_retention_days  = 7
  purge_protection_enabled    = false
  rbac_authorization_enabled  = false

  # Access policy for your account
  access_policy {
    tenant_id = var.tenant_id
    object_id = var.object_id
    
    key_permissions = [
      "Get", "List", "Create", "Delete", "Update", "Recover", "Backup", "Restore", "Purge"
    ]

    secret_permissions = [
      "Get", "List", "Set", "Delete", "Recover", "Backup", "Restore", "Purge"
    ]

    certificate_permissions = [
      "Get", "List", "Create", "Delete", "Update", "Recover", "Backup", "Restore", "Import", "Purge"
    ]
  }

# Access for frontend VMSS managed identity
   dynamic "access_policy" {
    for_each = var.frontend_identity_principal_id != null ? [1] : []
    content {
      tenant_id = var.tenant_id
      object_id = var.frontend_identity_principal_id
      secret_permissions = ["Get", "List"]
    }
  }

# Access for backend VMSS managed identity
   dynamic "access_policy" {
    for_each = var.backend_identity_principal_id != null ? [1] : []
    content {
      tenant_id = var.tenant_id
      object_id = var.backend_identity_principal_id
      secret_permissions = ["Get", "List"]
    }
  }

  tags = var.tags
}

# 



  # ssh keys as secrets
  resource "azurerm_key_vault_secret" "frontend_ssh" {
    name         = "frontend-ssh-key"
    value        = var.frontend_ssh_key
    key_vault_id = azurerm_key_vault.kv.id
  }

  resource "azurerm_key_vault_secret" "backend_ssh" {
    name         = "backend-ssh-key"
    value        = var.backend_ssh_key
    key_vault_id = azurerm_key_vault.kv.id
  } 


