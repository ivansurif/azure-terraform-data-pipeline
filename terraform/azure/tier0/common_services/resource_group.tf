resource "azurerm_resource_group" "common" {
  name     = local.rg
  location = local.rg_location
}
