variable "resource_name_prefix" {
  description = "Prefix for resource names"
  type        = string
}

variable "resource_group_name" {
    description = "Name of the resource group"
    type        = string
}

variable "location" {
    description = "Azure location for resources"
    type        = string
}

variable "vnet_address_space" {
    description = "Address space for the virtual network"
    type        = string
}

variable "public_subnets_prefixes" {
    description = "List of address prefixes for public subnets"
    type        = list(string)
}

variable "private_subnets_prefixes" {
    description = "List of address prefixes for private subnets"
    type        = list(string)
}

variable "database_subnets_prefixes" {
    description = "List of address prefixes for private subnets"
    type        = list(string)
}

variable "bastion_subnet_prefix" {
    description = "Address prefix for Bastion subnet"
    type        = string
}

variable "appgw_subnet_prefix" {
    description = "Address prefix for Application Gateway subnet"
    type        = string
}


variable "tags" {
    description = "Tags to apply to resources"
    type        = map(string)
}