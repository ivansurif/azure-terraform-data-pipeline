resource "azurerm_resource_group" "rg" {
  for_each = toset(local.resource_group_names)
  name     = each.key
  location = local.resource_group_location
}

