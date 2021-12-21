# Create RBAC Service Principal for each resource group to protect deployment
resource "azuread_application" "rg_app_reg" {
  foreach      = local.resource_group_names
  display_name = "sp-${each.value}"
}

resource "azuread_service_principal" "rg_sp" {
  foreach                      = local.resource_group_names
  application_id               = azuread_application.rg_app_reg[each.value].application_id
  app_role_assignment_required = false
}

resource "azuread_service_principal_password" "sp_password" {
  for_each             = local.resource_group_names
  service_principal_id = azuread_service_principal.rg_sp[each.value].object_id
  end_date             = "2099-01-01T01:00:00"
}

resource "azurerm_role_assignment" "example" {
  foreach              = local.resource_group_names
  scope                = azurerm_resource_group.rg[each.value].id
  role_definition_name = "Contributor"
  principal_id         = azuread_service_principal.rg_sp[each.value].object_id
}