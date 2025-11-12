# Output the Application Gateway Public IP
output "appgw_public_ip" {
  description = "Public IP address of the Application Gateway"
  value       = azurerm_public_ip.appgw_pip.ip_address
}

# Output the Application Gateway ID
output "appgw_id" {
  description = "ID of the Application Gateway"
  value       = azurerm_application_gateway.appgw.id
}

# Output the SSH Private Key
output "ssh_private_key" {
  description = "Private key for SSH access to the VMs (for administrative purpose only)"
  value       = tls_private_key.ssh.private_key_pem
  sensitive   = true
}

output "identity_principal_id" {
  description = "Principal ID of the Managed Identity"
  value       = azurerm_user_assigned_identity.frontend_vmss_identity.principal_id
}

output "managed_identity_id" {
  description = "ID of the User Assigned Managed Identity"
  value       = azurerm_user_assigned_identity.frontend_vmss_identity.id
}