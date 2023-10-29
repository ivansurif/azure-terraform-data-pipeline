resource "azurerm_eventgrid_topic" "azurerm_eventgrid_topic" {
  name                = var.custom_topic_name
  resource_group_name = var.resource_group_name
  location            = var.location

}