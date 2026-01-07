variable "resource_group_name" {
  description = "Name of the resource group for compute resources"
  type        = string
}

variable "location" {
  description = "Azure region for resources"
  type        = string
}

variable "identity_name" {
  description = "Name of the user-assigned managed identity"
  type        = string
}

variable "vmss_name" {
  description = "Name of the VM Scale Set"
  type        = string
}

variable "vm_sku" {
  description = "SKU/size of the VMs (e.g., Standard_B2s, Standard_D2s_v3)"
  type        = string
}

variable "vmss_instance_count" {
  description = "Number of VM instances in the scale set (0 to skip creation)"
  type        = number
}

variable "subnet_id" {
  description = "ID of the subnet for VM network interfaces"
  type        = string
}

variable "admin_username" {
  description = "Admin username for VMs"
  type        = string
}

variable "ssh_public_key" {
  description = "SSH public key for VM authentication"
  type        = string
}

variable "os_disk_type" {
  description = "Storage account type for OS disks (Standard_LRS, Premium_LRS)"
  type        = string
  default     = "Premium_LRS"
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
}
