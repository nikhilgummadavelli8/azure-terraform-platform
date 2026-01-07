variable "aks_cluster_id" {
  description = "Resource ID of the AKS cluster for role assignments"
  type        = string
}

variable "aks_admin_principal_ids" {
  description = "List of Azure AD principal IDs (users/groups) to grant AKS admin access"
  type        = list(string)
  default     = []
}

variable "aks_user_principal_ids" {
  description = "List of Azure AD principal IDs (users/groups) to grant AKS user access"
  type        = list(string)
  default     = []
}

variable "node_pool_identity_id" {
  description = "Principal ID of the AKS node pool managed identity"
  type        = string
  default     = null
}

variable "vnet_id" {
  description = "Resource ID of the virtual network for network contributor role"
  type        = string
}

variable "acr_id" {
  description = "Resource ID of Azure Container Registry for ACR pull role (optional)"
  type        = string
  default     = null
}
