output "vessel_supply_service_az_function_rg_id" {
  value = azurerm_resource_group.vessel_supply_service_az_function_rg.id
}

# waiting for a solution
# output "vessel_supply_service_az_functions_object_id" {
#   value = azurerm_function_app.functions[*].id
# }
