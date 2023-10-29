resource "azurerm_eventgrid_topic" "azurerm_eventgrid_topic" {
  name                = var.custom_topic_name
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name

}