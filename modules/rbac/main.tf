# RBAC Module - Manages Azure Role Assignments
# This module is environment-agnostic and reusable across all workspaces

# AKS Cluster Admin Role Assignment
resource "azurerm_role_assignment" "aks_admin" {
  for_each             = toset(var.aks_admin_principal_ids)
  scope                = var.aks_cluster_id
  role_definition_name = "Azure Kubernetes Service Cluster Admin Role"
  principal_id         = each.value
}

# AKS Cluster User Role Assignment (optional)
resource "azurerm_role_assignment" "aks_user" {
  for_each             = toset(var.aks_user_principal_ids)
  scope                = var.aks_cluster_id
  role_definition_name = "Azure Kubernetes Service Cluster User Role"
  principal_id         = each.value
}

# Network Contributor Role for AKS Kubelet Identity
resource "azurerm_role_assignment" "aks_network" {
  count                = var.node_pool_identity_id != null && var.node_pool_identity_id != "" ? 1 : 0
  scope                = var.vnet_id
  role_definition_name = "Network Contributor"
  principal_id         = var.node_pool_identity_id
}

# ACR Pull Role for AKS (if ACR ID is provided)
resource "azurerm_role_assignment" "acr_pull" {
  count                = var.acr_id != null && var.node_pool_identity_id != null ? 1 : 0
  scope                = var.acr_id
  role_definition_name = "AcrPull"
  principal_id         = var.node_pool_identity_id
}
