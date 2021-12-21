# Create RBAC Service Principal for each resource group to protect deployment
resource "azuread_application" "rg_app_reg" {
  for_each     = toset(local.resource_group_names)
  display_name = "sp-${each.value}"
}

resource "azuread_service_principal" "rg_sp" {
  for_each                     = toset(local.resource_group_names)
  application_id               = azuread_application.rg_app_reg[each.value].application_id
  app_role_assignment_required = false
}

resource "azuread_service_principal_password" "sp_password" {
  for_each             = toset(local.resource_group_names)
  service_principal_id = azuread_service_principal.rg_sp[each.value].object_id
}

resource "azurerm_role_assignment" "example" {
  for_each             = toset(local.resource_group_names)
  scope                = azurerm_resource_group.rg[each.value].id
  role_definition_name = "Contributor"
  principal_id         = azuread_service_principal.rg_sp[each.value].object_id
}