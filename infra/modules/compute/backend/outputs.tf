# Outputs for backend compute module
# output vmss id
output "vmss_id" {
  description = "ID of the Backend VM Scale Set"
  value       = azurerm_linux_virtual_machine_scale_set.backend_vmss.id
}

# output lb id
output "lb_id" {
  description = "ID of the Load Balancer"
  value       = azurerm_lb.lb.id
}

# output load balancer private ip
output "lb_private_ip" {
  description = "Private IP address of the Load Balancer"
  value       = azurerm_lb.lb.frontend_ip_configuration[0].private_ip_address
} 

# output ssh key
output "ssh_private_key" {
  description = "Private key for SSH access to the VMs (for administrative purpose only)"
  value       = tls_private_key.ssh.private_key_pem
  sensitive   = true
}

# output managed identity principal id
output "identity_principal_id" {
  description = "Principal ID of the Managed Identity"
  value       = azurerm_user_assigned_identity.backend_vmss_identity.principal_id
}

# output managed identity id
output "managed_identity_id" {
  description = "ID of the User Assigned Managed Identity"
  value       = azurerm_user_assigned_identity.backend_vmss_identity.id
}