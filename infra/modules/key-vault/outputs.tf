
# Outputs
output "kv_id" {
  value = azurerm_key_vault.kv.id
}

# URI of the Key Vault
output "kv_uri" {
  value = azurerm_key_vault.kv.vault_uri
}

