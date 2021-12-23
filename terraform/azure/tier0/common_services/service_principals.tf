
resource "azuread_application" "rg_aks_app" {
  display_name = "sp-integration-aks"
}

resource "azuread_service_principal" "rg_sp_aks_app" {
  application_id               = azuread_application.rg_aks_app.application_id
  app_role_assignment_required = false
}


resource "azurerm_role_assignment" "role_aks_app" {
  scope                = azurerm_kubernetes_cluster.aks.id
  role_definition_name = "Contributor"
  principal_id         = azuread_service_principal.rg_sp_aks_app.object_id
}