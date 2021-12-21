resource "azurerm_app_service_plan" "asp" {
  name                = local.app_service_plan_name
  location            = azurerm_resource_group.common.location
  resource_group_name = azurerm_resource_group.common.name
  kind                = local.app_service_plan_kind
  reserved            = true

  sku {
    tier = local.app_service_plan_tier
    size = local.app_service_plan_size
  }
}