resource "azurerm_function_app" "functions" {
  merged_functions_map       = merge(local.function_apps, local.files_upload_function_apps)
  for_each                   = merged_functions_map
  name                       = each.key
  location                   = azurerm_resource_group.rg[each.value["resource_group_name"]].location
  resource_group_name        = azurerm_resource_group.rg[each.value["resource_group_name"]].name
  app_service_plan_id        = data.terraform_remote_state.common_services.outputs.app_service_plan_id
  storage_account_name       = local.storage_account_name
  storage_account_access_key = local.primary_blob_access_key
  os_type                    = "linux"
  version                    = "~3"


  app_settings = merge(
    {
      APPINSIGHTS_INSTRUMENTATIONKEY = data.terraform_remote_state.common_services.outputs.insights_instrumentation_key
    },
    each.value["app_settings"],
    { for key, secret in each.value["secrets"] : key => "@Microsoft.KeyVault(VaultName=${local.key_vault_name};SecretName=${secret})" }
  )

  identity {
    type = "SystemAssigned"
  }

  site_config {
    always_on        = each.value["always_on"]
    linux_fx_version = each.value["linux_fx_version"]
    scm_type         = "LocalGit"
  }
}

resource "azurerm_key_vault_access_policy" "function_app_policies" {
  merged_functions_map = merge(local.function_apps, local.files_upload_function_apps)
  for_each     = merged_functions_map
  key_vault_id = local.key_vault_id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = azurerm_function_app.functions[each.key].identity[0].principal_id

  secret_permissions = [
    "Get",
  ]
  key_permissions     = []
  storage_permissions = []
}
