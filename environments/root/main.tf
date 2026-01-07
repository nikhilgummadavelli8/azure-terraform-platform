# Root Configuration - Orchestrates all modules with workspace-aware configuration
# This is the ONLY file that should be executed (terraform init/plan/apply)

locals {
  workspace = terraform.workspace

  # Workspace-specific configuration map
  # All environment differences are driven by this map
  environment_config = {
    dev = {
      location                = "East US"
      vnet_address_space      = ["10.0.0.0/16"]
      aks_subnet_prefixes     = ["10.0.1.0/24"]
      compute_subnet_prefixes = ["10.0.2.0/24"]
      aks_node_count          = 1
      aks_node_vm_size        = "Standard_B2s"
      vmss_instance_count     = 1
      vm_sku                  = "Standard_B1s"
      enable_autoscaling      = false
      min_node_count          = 1
      max_node_count          = 3
    }
    stage = {
      location                = "East US"
      vnet_address_space      = ["10.1.0.0/16"]
      aks_subnet_prefixes     = ["10.1.1.0/24"]
      compute_subnet_prefixes = ["10.1.2.0/24"]
      aks_node_count          = 2
      aks_node_vm_size        = "Standard_D2s_v3"
      vmss_instance_count     = 2
      vm_sku                  = "Standard_B2s"
      enable_autoscaling      = true
      min_node_count          = 2
      max_node_count          = 5
    }
    prod = {
      location                = "East US"
      vnet_address_space      = ["10.2.0.0/16"]
      aks_subnet_prefixes     = ["10.2.1.0/24"]
      compute_subnet_prefixes = ["10.2.2.0/24"]
      aks_node_count          = 3
      aks_node_vm_size        = "Standard_D4s_v3"
      vmss_instance_count     = 3
      vm_sku                  = "Standard_D2s_v3"
      enable_autoscaling      = true
      min_node_count          = 3
      max_node_count          = 10
    }
  }

  # ============================================================================
  # CONFIGURATION SELECTOR - This is the "magic" line
  # ============================================================================
  # terraform.workspace returns active workspace name → used to index into map
  # Result: local.config contains all settings for current environment
  # Example: If workspace="dev", then local.config.aks_node_count = 1
  # ============================================================================
  config = local.environment_config[local.workspace]

  # Common tags applied to ALL resources
  # Tags help with cost tracking, organization, and compliance
  common_tags = {
    Environment = local.workspace
    ManagedBy   = "Terraform"
    Project     = var.project_name
    Workspace   = local.workspace
  }
}

# ============================================================================
# NETWORK MODULE - Foundation Layer
# ============================================================================
# Creates the networking foundation: VNet, subnets
# This module is called FIRST because all other modules depend on it
# Note: Resource names include workspace for environment isolation
# ============================================================================
module "network" {
  source = "../../modules/network" # Relative path to reusable module

  # Dynamic naming pattern: project-workspace-resource
  # Example: "azplatform-dev-network-rg" for dev workspace
  resource_group_name     = "${var.project_name}-${local.workspace}-network-rg"
  location                = local.config.location # From workspace config
  vnet_name               = "${var.project_name}-${local.workspace}-vnet"
  vnet_address_space      = local.config.vnet_address_space
  aks_subnet_name         = "aks-subnet"
  aks_subnet_prefixes     = local.config.aks_subnet_prefixes
  compute_subnet_name     = "compute-subnet"
  compute_subnet_prefixes = local.config.compute_subnet_prefixes
  tags                    = local.common_tags
}

# Compute Module - VM Scale Sets with Managed Identities
module "compute" {
  source = "../../modules/compute"

  resource_group_name = module.network.resource_group_name
  location            = module.network.location
  identity_name       = "${var.project_name}-${local.workspace}-vmss-identity"
  vmss_name           = "${var.project_name}-${local.workspace}-vmss"
  vm_sku              = local.config.vm_sku              # Workspace-specific VM size
  vmss_instance_count = local.config.vmss_instance_count # Number of VM instances
  subnet_id           = module.network.compute_subnet_id # From network module output
  admin_username      = var.admin_username
  ssh_public_key      = var.ssh_public_key
  os_disk_type        = "Premium_LRS"
  tags                = local.common_tags
}

# ============================================================================
# AKS MODULE - Azure Kubernetes Service
# ============================================================================
# Creates managed Kubernetes cluster with workspace-specific sizing
# DEPENDENCY: Requires network module (uses subnet and resource group)
# ============================================================================
module "aks" {
  source = "../../modules/aks"

  resource_group_name    = module.network.resource_group_name
  location               = module.network.location
  cluster_name           = "${var.project_name}-${local.workspace}-aks"
  dns_prefix             = "${var.project_name}-${local.workspace}"
  kubernetes_version     = var.kubernetes_version
  system_node_count      = local.config.aks_node_count   # Workspace-specific node count
  system_node_vm_size    = local.config.aks_node_vm_size # Workspace-specific VM size
  aks_subnet_id          = module.network.aks_subnet_id  # From network module
  enable_autoscaling     = local.config.enable_autoscaling
  min_node_count         = local.config.min_node_count
  max_node_count         = local.config.max_node_count
  os_disk_size_gb        = 128
  service_cidr           = "10.100.0.0/16"
  dns_service_ip         = "10.100.0.10"
  admin_group_object_ids = var.aks_admin_group_ids
  tags                   = local.common_tags
}

# RBAC Module - Azure Role Assignments
module "rbac" {
  source = "../../modules/rbac"

  aks_cluster_id          = module.aks.cluster_id
  aks_admin_principal_ids = var.aks_admin_principal_ids
  aks_user_principal_ids  = var.aks_user_principal_ids
  node_pool_identity_id   = module.aks.kubelet_identity_object_id
  vnet_id                 = module.network.vnet_id
  acr_id                  = var.acr_id
}
