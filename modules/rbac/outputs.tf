output "aks_admin_role_assignment_ids" {
  description = "IDs of AKS admin role assignments"
  value       = [for ra in azurerm_role_assignment.aks_admin : ra.id]
}

output "aks_user_role_assignment_ids" {
  description = "IDs of AKS user role assignments"
  value       = [for ra in azurerm_role_assignment.aks_user : ra.id]
}

output "network_role_assignment_id" {
  description = "ID of the network contributor role assignment"
  value       = length(azurerm_role_assignment.aks_network) > 0 ? azurerm_role_assignment.aks_network[0].id : null
}
