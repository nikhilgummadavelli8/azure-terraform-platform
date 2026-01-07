# ============================================================================
# NETWORK MODULE - Environment-Agnostic Networking Foundation
# ============================================================================
# This module is REUSABLE and ENVIRONMENT-AGNOSTIC. It has NO knowledge of
# whether it's being used for dev, stage, or prod. All environment-specific
# values (names, CIDRs) are passed in as variables from the caller.
# ============================================================================

# Create resource group for all network resources
# This provides logical grouping and lifecycle management
resource "azurerm_resource_group" "network" {
  name     = var.resource_group_name # Passed from root (includes workspace)
  location = var.location            # Passed from root (workspace-specific)
  tags     = var.tags                # Common tags for organization
}

# Create virtual network (VNet) - the foundation of Azure networking
# VNet provides private IP space and network isolation
resource "azurerm_virtual_network" "main" {
  name                = var.vnet_name          # Dynamic from root configuration
  address_space       = var.vnet_address_space # CIDR blocks (e.g., ["10.0.0.0/16"])
  location            = azurerm_resource_group.network.location
  resource_group_name = azurerm_resource_group.network.name
  tags                = var.tags
}

# Create subnet specifically for AKS (Kubernetes) nodes
# Separate subnets provide network segmentation and security
resource "azurerm_subnet" "aks" {
  name                 = var.aks_subnet_name # Descriptive name (e.g., "aks-subnet")
  resource_group_name  = azurerm_resource_group.network.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = var.aks_subnet_prefixes # Subset of VNet CIDR
}

# Create subnet for general compute workloads (VMs, VMSS)
resource "azurerm_subnet" "compute" {
  name                 = var.compute_subnet_name
  resource_group_name  = azurerm_resource_group.network.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = var.compute_subnet_prefixes # Different from AKS subnet
}
