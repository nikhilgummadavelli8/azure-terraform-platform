# ============================================================================
# TAGS MODULE - Standardized Resource Tagging
# ============================================================================
# This module generates consistent tags for all resources.
# 
# Benefits:
# - Single source of truth for tagging strategy
# - Ensures compliance with organizational standards
# - Simplifies cost tracking and resource management
# - Easy to add/modify tags globally
# ============================================================================

locals {
  # Required tags - applied to ALL resources
  required_tags = {
    Environment = var.workspace
    ManagedBy   = "Terraform"
    Project     = var.project_name
    Workspace   = var.workspace
  }

  # Optional tags - can be provided by caller
  optional_tags = var.additional_tags

  # Merge required and optional tags
  # Required tags take precedence if there's a conflict
  all_tags = merge(
    local.optional_tags,
    local.required_tags
  )
}
