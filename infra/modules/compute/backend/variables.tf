variable "resource_name_prefix" {
  description = "Prefix for resource names"
  type        = string
}
variable "resource_group_name" {
    description = "Name of the resource group"
    type        = string
}

variable "environment" {
  description = "Deployment environment (e.g., dev, prod)"
  type        = string
}

variable "location" {
    description = "Azure location for resources"
    type        = string
}

variable "subnet_id" {
    description = "value of private subnet ids"
    type = string
}

variable "backend_instance_count" {
    description = "Number of frontend instances"
    type        = number
}

variable "tags" {
    description = "Tags to apply to resources"
    type        = map(string)
}