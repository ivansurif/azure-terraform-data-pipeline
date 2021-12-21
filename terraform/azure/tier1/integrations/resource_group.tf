resource "azurerm_resource_group" "rg" {
  foreach = local.resource_group_names
  name     = each.value
  location = local.resource_group_location
}


