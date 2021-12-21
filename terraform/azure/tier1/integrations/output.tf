output "sp_credentials" {
  sensitive = true
  value = {
    for key in local.resource_group_names : "${key}" => {
      CLIENT_ID      = azuread_application.rg_app_reg[key].application_id
      CLIENT_SECRET  = azuread_service_principal_password.sp_password[key].value
      TENANT_ID      = data.azurerm_client_config.current.tenant_id
      SUBSCIPTION_ID = data.azurerm_client_config.current.subscription_id
    }
  }
}