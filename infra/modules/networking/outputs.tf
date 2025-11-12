# Output the VNet ID
output "vnet_id" {
  value = azurerm_virtual_network.main.id
}

# output the vnet name
output "vnet_name" {
  value = azurerm_virtual_network.main.name
}

# Output public Subnet IDs
output "public_subnet_ids" {
  description = "IDs of public subnets"
  value       = azurerm_subnet.frontend[*].id
}


# Output private Subnet IDs
output "private_subnet_ids" {
  description = "IDs of private subnets"
  value       = azurerm_subnet.backend[*].id
}

# Output database Subnet IDs
output "database_subnet_ids" {
  description = "IDs of database subnets"
  value       = azurerm_subnet.db[*].id
}

# Output Bastion Subnet ID
output "bastion_subnet_id" {
  description = "ID of the Bastion subnet"
  value       = azurerm_subnet.bastion.id
}

# Output Application Gateway Subnet ID
output "appgw_subnet_id" {
  description = "ID of the Application Gateway subnet"
  value       = azurerm_subnet.gateway.id
}

output "public_nsg_id" {
  description = "ID of the public Network Security Group"
  value       = azurerm_network_security_group.public.id
}

output "private_nsg_id" {
  description = "ID of the private Network Security Group"
  value       = azurerm_network_security_group.private.id
}

output "database_nsg_id" {
  description = "ID of the database Network Security Group"
  value       = azurerm_network_security_group.database.id
}

output "bastion_host_name" {
  description = "Name of the Bastion Host"
  value       = azurerm_bastion_host.bastion.name
}
