resource "azurerm_container_registry" "acr" {
  name                = local.container_registry_name
  resource_group_name = azurerm_resource_group.common.name
  location            = azurerm_resource_group.common.location
  sku                 = local.container_registry_sku
  admin_enabled       = true
}