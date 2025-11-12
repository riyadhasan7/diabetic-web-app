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

variable "appgw_subnet_id" {
    description = "Subnet ID for Application Gateway"
    type        = string
}

variable "public_subnets_prefixes" {
    description = "List of address prefixes for public subnets"
    type        = list(string)
}

variable "frontend_instance_count" {
    description = "Number of frontend instances"
    type        = number
}

variable "subnet_id" {
    description = "Subnet ID for frontend instances"
    type        = string
}

variable "tags" {
    description = "Tags to apply to resources"
    type        = map(string)
}