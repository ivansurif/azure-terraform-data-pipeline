output "resource_group_id" {
  description = "The ID of the resource group created in Tier 0"
  value       = module.tier0_foundational.resource_group_id
}

output "resource_group_name" {
  value = module.tier0_foundational.resource_group_name
}
