# AKS Module - Provisions Azure Kubernetes Service Cluster
# This module is environment-agnostic and reusable across all workspaces

resource "azurerm_kubernetes_cluster" "main" {
  name                = var.cluster_name
  location            = var.location
  resource_group_name = var.resource_group_name
  dns_prefix          = var.dns_prefix
  kubernetes_version  = var.kubernetes_version

  default_node_pool {
    name                 = "system"
    node_count           = var.enable_autoscaling ? null : var.system_node_count
    vm_size              = var.system_node_vm_size
    vnet_subnet_id       = var.aks_subnet_id
    auto_scaling_enabled = var.enable_autoscaling
    min_count            = var.enable_autoscaling ? var.min_node_count : null
    max_count            = var.enable_autoscaling ? var.max_node_count : null
    os_disk_size_gb      = var.os_disk_size_gb
    type                 = "VirtualMachineScaleSets"

    upgrade_settings {
      max_surge = "10%"
    }
  }

  identity {
    type = "SystemAssigned"
  }

  network_profile {
    network_plugin    = "azure"
    network_policy    = "azure"
    service_cidr      = var.service_cidr
    dns_service_ip    = var.dns_service_ip
    load_balancer_sku = "standard"
  }

  azure_active_directory_role_based_access_control {
    azure_rbac_enabled     = true
    admin_group_object_ids = var.admin_group_object_ids
  }

  tags = var.tags

  lifecycle {
    ignore_changes = [
      default_node_pool[0].node_count
    ]
  }
}
