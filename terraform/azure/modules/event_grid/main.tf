resource "azurerm_eventgrid_topic" "example" {
  name                = var.custom_topic_name
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name

}