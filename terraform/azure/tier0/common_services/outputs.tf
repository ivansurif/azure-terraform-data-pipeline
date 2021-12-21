output "resoure_group_id" {
  value = azurerm_resource_group.common.id
}

output "resource_group_location" {
  value = azurerm_resource_group.common.location
}

output "app_service_plan_id" {
  value = azurerm_app_service_plan.asp.id
}

output "insights_instrumentation_key" {
  value     = azurerm_application_insights.insights.instrumentation_key
  sensitive = true
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

