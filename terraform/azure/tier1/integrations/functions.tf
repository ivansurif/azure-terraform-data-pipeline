resource "azurerm_function_app" "functions" {
  for_each            = local.function_apps
  name                = each.key
  location            = azurerm_resource_group.vessel_supply_service_az_function_rg.location
  resource_group_name = azurerm_resource_group.vessel_supply_service_az_function_rg.name
  # TODO: adopt azurerm_app_service_plan.asp[each.value["app_service_plan"]].id
  app_service_plan_id        = data.terraform_remote_state.trading_common_services.outputs.trading_app_service_plan_id
  storage_account_name       = local.storage_account_name
  storage_account_access_key = local.primary_blob_access_key
  os_type                    = "linux"
  version                    = "~3"


  app_settings = merge(
    {
      APPINSIGHTS_INSTRUMENTATIONKEY = data.terraform_remote_state.trading_common_services.outputs.trading_common_service_insights_instrumentation_key
    },
    each.value["app_settings"],
    { for key, secret in each.value["secrets"] : key => "@Microsoft.KeyVault(VaultName=${local.key_vault_name};SecretName=${secret})" }
  )

  identity {
    type = "SystemAssigned"
  }

  site_config {
    always_on = each.value["always_on"]
    # linux_fx_version = each.value["linux_fx_version"]
  }
}

resource "azurerm_key_vault_access_policy" "function_app_policies" {
  for_each     = local.function_apps
  key_vault_id = local.key_vault_id
  tenant_id    = module.project_vars.tenant_id
  object_id    = azurerm_function_app.functions[each.key].identity[0].principal_id

  secret_permissions = [
    "Get",
  ]
  key_permissions     = []
  storage_permissions = []
}
