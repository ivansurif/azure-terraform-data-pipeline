output "site_credentials" {
  sensitive   = true
  value = { for key, value in local.function_apps : "${key}" => azurerm_function_app.functions[key].site_credential } 
}