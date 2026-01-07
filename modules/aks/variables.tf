variable "resource_group_name" {
  description = "Name of the resource group for AKS cluster"
  type        = string
}

variable "location" {
  description = "Azure region for the AKS cluster"
  type        = string
}

variable "cluster_name" {
  description = "Name of the AKS cluster"
  type        = string
}

variable "dns_prefix" {
  description = "DNS prefix for the AKS cluster"
  type        = string
}

variable "kubernetes_version" {
  description = "Kubernetes version for the cluster"
  type        = string
  default     = "1.28"
}

variable "system_node_count" {
  description = "Number of nodes in the system node pool (ignored if autoscaling enabled)"
  type        = number
  default     = 1
}

variable "system_node_vm_size" {
  description = "VM size for system node pool"
  type        = string
}

variable "aks_subnet_id" {
  description = "ID of the subnet for AKS nodes"
  type        = string
}

variable "enable_autoscaling" {
  description = "Enable autoscaling for the default node pool"
  type        = bool
  default     = false
}

variable "min_node_count" {
  description = "Minimum number of nodes when autoscaling is enabled"
  type        = number
  default     = 1
}

variable "max_node_count" {
  description = "Maximum number of nodes when autoscaling is enabled"
  type        = number
  default     = 5
}

variable "os_disk_size_gb" {
  description = "OS disk size in GB for nodes"
  type        = number
  default     = 128
}

variable "service_cidr" {
  description = "CIDR for Kubernetes services"
  type        = string
}

variable "dns_service_ip" {
  description = "IP address for Kubernetes DNS service"
  type        = string
}

variable "admin_group_object_ids" {
  description = "Azure AD group object IDs for cluster admin access"
  type        = list(string)
  default     = []
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
}
