output "resoure_group_id" {
  value = azurerm_resource_group.common.id
}

output "resource_group_location" {
  value = azurerm_resource_group.common.location
}

output "resource_group_name" {
  value = azurerm_resource_group.common.name
}

output "app_service_plan_id" {
  value = azurerm_app_service_plan.asp.id
}

output "app_service_plan_name" {
  value = azurerm_app_service_plan.asp.name
}

output "insights_instrumentation_key" {
  value     = azurerm_application_insights.insights.instrumentation_key
  sensitive = true
}

output "insights_id" {
  value     = azurerm_application_insights.insights.id
}

output "action_group_id" {
  value     = azurerm_monitor_action_group.action_group.id
}

output "storage_account_primary_blob_endpoint" {
  value = azurerm_storage_account.storage.primary_blob_endpoint
}
output "storage_account_name" {
  value = azurerm_storage_account.storage.name
}

output "storage_account_primary_access_key" {
  value     = azurerm_storage_account.storage.primary_access_key
  sensitive = true
}

output "container_registry_login_server" {
  value = azurerm_container_registry.acr.login_server
}

output "container_registry_admin_username" {
  value = azurerm_container_registry.acr.admin_username
}

output "container_registry_admin_password" {
  value     = azurerm_container_registry.acr.admin_password
  sensitive = true
}

output "key_vault_name" {
  value = azurerm_key_vault.key_vault.name
}
output "key_vault_id" {
  value = azurerm_key_vault.key_vault.id
}

