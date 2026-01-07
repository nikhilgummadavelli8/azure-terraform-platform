variable "project_name" {
  description = "Name of the project (used as prefix for all resources)"
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.project_name))
    error_message = "Project name must contain only lowercase letters, numbers, and hyphens."
  }
}

variable "workspace" {
  description = "Current Terraform workspace (dev, stage, prod, etc.)"
  type        = string
}
