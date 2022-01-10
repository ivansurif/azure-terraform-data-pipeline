resource "azurerm_resource_group" "common" {
  name     = local.resource_group_name
  location = local.resource_group_location
}

resource "azurerm_resource_group" "rg_files_upload_dev" {
  name     = element(toset(local.resource_group_names_files_upload), 0)
  location = local.resource_group_location
}

resource "azurerm_resource_group" "rg_files_upload_test" {
  name     = element(toset(local.resource_group_names_files_upload), 1)
  location = local.resource_group_location
}

resource "azurerm_resource_group" "rg_files_upload_prod" {
  name     = element(toset(local.resource_group_names_files_upload), 2)
  location = local.resource_group_location
}
