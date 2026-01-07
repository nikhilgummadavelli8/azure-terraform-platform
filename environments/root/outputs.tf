# Root Outputs - Aggregates outputs from all modules

output "workspace" {
  description = "Current Terraform workspace"
  value       = terraform.workspace
}

output "environment" {
  description = "Current environment name"
  value       = terraform.workspace
}

# Network Outputs
output "vnet_id" {
  description = "ID of the virtual network"
  value       = module.network.vnet_id
}

output "vnet_name" {
  description = "Name of the virtual network"
  value       = module.network.vnet_name
}

output "aks_subnet_id" {
  description = "ID of the AKS subnet"
  value       = module.network.aks_subnet_id
}

output "compute_subnet_id" {
  description = "ID of the compute subnet"
  value       = module.network.compute_subnet_id
}

# Compute Outputs
output "vmss_identity_principal_id" {
  description = "Principal ID of the VMSS managed identity"
  value       = module.compute.identity_principal_id
}

output "vmss_id" {
  description = "ID of the VM Scale Set"
  value       = module.compute.vmss_id
}

# AKS Outputs
output "aks_cluster_name" {
  description = "Name of the AKS cluster"
  value       = module.aks.cluster_name
}

output "aks_cluster_id" {
  description = "ID of the AKS cluster"
  value       = module.aks.cluster_id
}

output "aks_cluster_fqdn" {
  description = "FQDN of the AKS cluster"
  value       = module.aks.cluster_fqdn
}

output "aks_kube_config" {
  description = "Kubeconfig for accessing the AKS cluster"
  value       = module.aks.kube_config
  sensitive   = true
}

output "aks_node_resource_group" {
  description = "Node resource group created by AKS"
  value       = module.aks.node_resource_group
}

# RBAC Outputs
output "aks_admin_role_assignments" {
  description = "IDs of AKS admin role assignments"
  value       = module.rbac.aks_admin_role_assignment_ids
}

# Connection Commands
output "get_aks_credentials_command" {
  description = "Command to get AKS credentials"
  value       = "az aks get-credentials --resource-group ${module.network.resource_group_name} --name ${module.aks.cluster_name}"
}
