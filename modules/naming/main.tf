# ============================================================================
# NAMING MODULE - Centralized Resource Naming Convention
# ============================================================================
# This module generates consistent resource names following the pattern:
# {project_name}-{workspace}-{resource_type}
# 
# Benefits:
# - Single source of truth for naming convention
# - Easy to change naming pattern globally
# - Ensures consistency across all resources
# ============================================================================

locals {
  # Standard naming pattern: project-workspace-resource
  # Example: azplatform-dev-vnet
  base_name = "${var.project_name}-${var.workspace}"

  # Generate all resource names using the base pattern
  names = {
    # Resource Group
    resource_group = "${local.base_name}-network-rg"

    # Networking
    vnet           = "${local.base_name}-vnet"
    aks_subnet     = "aks-subnet"
    compute_subnet = "compute-subnet"

    # Compute
    vmss          = "${local.base_name}-vmss"
    vmss_identity = "${local.base_name}-vmss-identity"

    # AKS
    aks_cluster = "${local.base_name}-aks"
    aks_dns     = local.base_name
  }
}
