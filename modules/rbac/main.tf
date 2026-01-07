# ============================================================================
# RBAC MODULE - Azure Role-Based Access Control
# ============================================================================
# This module manages Azure AD role assignments for AKS and network access.
# It's environment-agnostic - all principal IDs are passed as variables.
# Uses for_each to create multiple role assignments from a list.
# ============================================================================

# AKS Cluster Admin Role Assignment
# Grants full administrative access to the AKS cluster
# Uses for_each to create one assignment per principal ID in the list
resource "azurerm_role_assignment" "aks_admin" {
  for_each             = toset(var.aks_admin_principal_ids) # Convert list to set
  scope                = var.aks_cluster_id                 # AKS cluster resource ID
  role_definition_name = "Azure Kubernetes Service Cluster Admin Role"
  principal_id         = each.value # Azure AD user/group object ID
}

# AKS Cluster User Role Assignment (optional)
# Grants read-only user access to the AKS cluster
resource "azurerm_role_assignment" "aks_user" {
  for_each             = toset(var.aks_user_principal_ids)
  scope                = var.aks_cluster_id
  role_definition_name = "Azure Kubernetes Service Cluster User Role"
  principal_id         = each.value
}

# Network Contributor Role for AKS Kubelet Identity
# Allows AKS to manage networking resources (load balancers, IPs, etc.)
# Uses count for conditional creation: only create if identity ID is provided
resource "azurerm_role_assignment" "aks_network" {
  count                = var.node_pool_identity_id != null && var.node_pool_identity_id != "" ? 1 : 0
  scope                = var.vnet_id
  role_definition_name = "Network Contributor"
  principal_id         = var.node_pool_identity_id # AKS kubelet managed identity
}

# ACR Pull Role for AKS (if ACR ID is provided)
# Allows AKS nodes to pull container images from Azure Container Registry
resource "azurerm_role_assignment" "acr_pull" {
  count                = var.acr_id != null && var.node_pool_identity_id != null ? 1 : 0
  scope                = var.acr_id # Container registry ID
  role_definition_name = "AcrPull"  # Built-in role for pulling images
  principal_id         = var.node_pool_identity_id
}
