variable "project_name" {
  description = "Name of the project"
  type        = string
}

variable "workspace" {
  description = "Current Terraform workspace (dev, stage, prod, etc.)"
  type        = string
}

variable "additional_tags" {
  description = "Additional tags to apply to resources (merged with required tags)"
  type        = map(string)
  default     = {}
}
