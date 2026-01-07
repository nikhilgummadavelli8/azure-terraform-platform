output "names" {
  description = "Map of all standardized resource names"
  value       = local.names
}

output "base_name" {
  description = "Base naming prefix (project-workspace)"
  value       = local.base_name
}

output "resource_group" {
  description = "Resource group name"
  value       = local.names.resource_group
}

output "vnet" {
  description = "Virtual network name"
  value       = local.names.vnet
}

output "aks_cluster" {
  description = "AKS cluster name"
  value       = local.names.aks_cluster
}

output "vmss" {
  description = "VM Scale Set name"
  value       = local.names.vmss
}
