resource "azurerm_resource_group" "common" {
  name     = local.rg
  location = local.resource_group_location
}
