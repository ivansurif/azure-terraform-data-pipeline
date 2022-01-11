resource "azurerm_resource_group" "rg" {
  for_each = toset(local.resource_group_names)
  name     = each.key
  location = local.resource_group_location
}

resource "azurerm_resource_group" "rg_files_upload" {
  for_each = toset(local.resource_group_names_files_upload)
  name     = each.key
  location = local.resource_group_location
}

