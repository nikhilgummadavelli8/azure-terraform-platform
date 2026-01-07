variable "resource_group_name" {
  description = "Name of the resource group for network resources"
  type        = string
}

variable "location" {
  description = "Azure region for resources"
  type        = string
}

variable "vnet_name" {
  description = "Name of the virtual network"
  type        = string
}

variable "vnet_address_space" {
  description = "Address space for the virtual network"
  type        = list(string)
}

variable "aks_subnet_name" {
  description = "Name of the AKS subnet"
  type        = string
}

variable "aks_subnet_prefixes" {
  description = "Address prefixes for the AKS subnet"
  type        = list(string)
}

variable "compute_subnet_name" {
  description = "Name of the compute subnet"
  type        = string
}

variable "compute_subnet_prefixes" {
  description = "Address prefixes for the compute subnet"
  type        = list(string)
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
}
