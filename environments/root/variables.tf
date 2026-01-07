variable "project_name" {
  description = "Name of the project, used for resource naming"
  type        = string
  default     = "azplatform"
}

variable "kubernetes_version" {
  description = "Kubernetes version for AKS cluster"
  type        = string
  default     = "1.28"
}

variable "admin_username" {
  description = "Admin username for VM Scale Sets"
  type        = string
  default     = "azureuser"
}

variable "ssh_public_key" {
  description = "SSH public key for VM authentication"
  type        = string
}

variable "aks_admin_group_ids" {
  description = "Azure AD group object IDs for AKS cluster admin access"
  type        = list(string)
  default     = []
}

variable "aks_admin_principal_ids" {
  description = "Azure AD principal IDs (users/groups) for AKS admin role assignment"
  type        = list(string)
  default     = []
}

variable "aks_user_principal_ids" {
  description = "Azure AD principal IDs (users/groups) for AKS user role assignment"
  type        = list(string)
  default     = []
}

variable "acr_id" {
  description = "Resource ID of Azure Container Registry for ACR pull role (optional)"
  type        = string
  default     = null
}
