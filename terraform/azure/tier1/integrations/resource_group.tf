resource "azurerm_resource_group" "vessel_supply_service_az_function_rg" {
  name     = local.resource_group_name
  location = local.resource_group_location
}


