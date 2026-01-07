output "vnet_id" {
  description = "ID of the virtual network"
  value       = azurerm_virtual_network.main.id
}

output "vnet_name" {
  description = "Name of the virtual network"
  value       = azurerm_virtual_network.main.name
}

output "resource_group_name" {
  description = "Name of the network resource group"
  value       = azurerm_resource_group.network.name
}

output "location" {
  description = "Azure region of the resources"
  value       = azurerm_resource_group.network.location
}

output "aks_subnet_id" {
  description = "ID of the AKS subnet"
  value       = azurerm_subnet.aks.id
}

output "compute_subnet_id" {
  description = "ID of the compute subnet"
  value       = azurerm_subnet.compute.id
}
