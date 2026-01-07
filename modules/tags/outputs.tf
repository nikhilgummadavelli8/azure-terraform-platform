output "tags" {
  description = "Complete map of tags to apply to all resources"
  value       = local.all_tags
}

output "required_tags" {
  description = "Required tags that are always applied"
  value       = local.required_tags
}
