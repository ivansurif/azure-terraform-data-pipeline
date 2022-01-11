# Resource Groups IDs

output "resoure_group_id" {
  value = azurerm_resource_group.common.id
}

output "resoure_group_id_files_upload_dev" {
  value = azurerm_resource_group.rg_files_upload_dev.id
}

output "resoure_group_id_files_upload_test" {
  value = azurerm_resource_group.rg_files_upload_test.id
}

output "resoure_group_id_files_upload_prod" {
  value = azurerm_resource_group.rg_files_upload_prod.id
}

# Resource Groups location

output "resource_group_location" {
  value = azurerm_resource_group.common.location
}

# Resource Groups Names

output "resource_group_name" {
  value = azurerm_resource_group.common.name
}

output "resource_group_name_files_upload_dev" {
  value = azurerm_resource_group.rg_files_upload_dev.name
}

output "resource_group_name_files_upload_test" {
  value = azurerm_resource_group.rg_files_upload_test.name
}

output "resource_group_name_files_upload_prod" {
  value = azurerm_resource_group.rg_files_upload_prod.name
}

# Service Plans IDs
output "app_service_plan_id" {
  value = azurerm_app_service_plan.asp.id
}

output "app_service_plan_id_files_upload" {
  value = azurerm_app_service_plan.asp_files_upload.id
}

# Service Plans Names

output "app_service_plan_name" {
  value = azurerm_app_service_plan.asp.name
}

output "app_service_plan_name_files_upload" {
  value = azurerm_app_service_plan.asp_files_upload.name
}

# Insights Instrumentation Keys

output "insights_instrumentation_key_files_upload_dev" {
  value     = azurerm_application_insights.insights_files_upload_dev.instrumentation_key
  sensitive = true
}

output "insights_instrumentation_key_files_upload_test" {
  value     = azurerm_application_insights.insights_files_upload_test.instrumentation_key
  sensitive = true
}

output "insights_instrumentation_key_files_upload_prod" {
  value     = azurerm_application_insights.insights_files_upload_prod.instrumentation_key
  sensitive = true
}

output "insights_instrumentation_key" {
  value     = azurerm_application_insights.insights.instrumentation_key
  sensitive = true
}

# Insights IDs

output "insights_id_files_upload_dev" {
  value = azurerm_application_insights.insights_files_upload_dev.id
}

output "insights_id_files_upload_test" {
  value = azurerm_application_insights.insights_files_upload_test.id
}

output "insights_id_files_upload_prod" {
  value = azurerm_application_insights.insights_files_upload_prod.id
}

output "insights_id" {
  value = azurerm_application_insights.insights.id
}

# Action Group IDs

output "action_group_id_files_upload_dev" {
  value = azurerm_monitor_action_group.action_group_files_upload_dev.id
}

output "action_group_id_files_upload_test" {
  value = azurerm_monitor_action_group.action_group_files_upload_test.id
}

output "action_group_id_files_upload_prod" {
  value = azurerm_monitor_action_group.action_group_files_upload_prod.id
}

output "action_group_id" {
  value = azurerm_monitor_action_group.action_group.id
}

# Storage account

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

# Container Registry

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

# Key Vault

output "key_vault_name" {
  value = azurerm_key_vault.key_vault.name
}
output "key_vault_id" {
  value = azurerm_key_vault.key_vault.id
}

