resource "azurerm_application_insights" "insights" {
  name                = "insights-${azurerm_resource_group.common.name}"
  location            = azurerm_resource_group.common.location
  resource_group_name = azurerm_resource_group.common.name
  application_type    = "web"
}
