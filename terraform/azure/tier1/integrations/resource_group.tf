resource "azurerm_resource_group" "rg" {
  name     = local.resource_group_name
  location = local.resource_group_location
}


