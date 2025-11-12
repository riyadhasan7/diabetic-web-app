variable "resource_group_name" {
    description = "The name of the resource group in which to create the Key Vault."
    type        = string
    }

variable "location" {
    description = "The Azure location where the Key Vault will be created."
    type        = string
}

variable "resource_name_prefix" {
    description = "Prefix for resource names."
    type        = string
}

variable "tenant_id" {
    description = "The Tenant ID for the Key Vault."
    type        = string
}

variable "object_id" {
    description = "The Object ID of the user or service principal to grant access to the Key Vault."
    type        = string
}

variable "frontend_identity_principal_id" {
  description = "The principal ID of the frontend VMSS managed identity."
  type        = string
  default     = null
}

variable "backend_identity_principal_id" {
  description = "The principal ID of the backend VMSS managed identity."
  type        = string
  default     = null
}

variable "frontend_ssh_key" {
  description = "SSH private key for the frontend VMSS."
  type        = string
}

variable "backend_ssh_key" {
  description = "SSH private key for the backend VMSS."
  type        = string
}

variable "tags" {
    description = "A map of tags to assign to the resource."
    type        = map(string)
}