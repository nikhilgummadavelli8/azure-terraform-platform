output "identity_principal_id" {
  description = "Principal ID of the user-assigned managed identity"
  value       = azurerm_user_assigned_identity.vmss.principal_id
}

output "identity_client_id" {
  description = "Client ID of the user-assigned managed identity"
  value       = azurerm_user_assigned_identity.vmss.client_id
}

output "identity_id" {
  description = "Resource ID of the user-assigned managed identity"
  value       = azurerm_user_assigned_identity.vmss.id
}

output "vmss_id" {
  description = "Resource ID of the VM Scale Set"
  value       = length(azurerm_linux_virtual_machine_scale_set.main) > 0 ? azurerm_linux_virtual_machine_scale_set.main[0].id : null
}

output "vmss_unique_id" {
  description = "Unique ID of the VM Scale Set"
  value       = length(azurerm_linux_virtual_machine_scale_set.main) > 0 ? azurerm_linux_virtual_machine_scale_set.main[0].unique_id : null
}
