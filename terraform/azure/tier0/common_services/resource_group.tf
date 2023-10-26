resource "azurerm_resource_group" "common" {
  name     = local.rg_name
  location = local.rg_location
}
