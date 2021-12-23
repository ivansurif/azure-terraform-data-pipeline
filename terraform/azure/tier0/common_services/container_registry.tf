resource "azurerm_container_registry" "acr" {
  name                = local.container_registry_name
  resource_group_name = azurerm_resource_group.common.name
  location            = azurerm_resource_group.common.location
  sku                 = local.container_registry_sku
  admin_enabled       = true
}


resource "azurerm_role_assignment" "role_aks_app_to_acr" {
  scope                = azurerm_container_registry.acr.id
  role_definition_name = "Contributor"
  principal_id         = azurerm_kubernetes_cluster.aks.id
}