resource "azurerm_kubernetes_cluster" "aks" {
  name                = local.aks_cluster_name
  location            = local.aks_cluster_location
  resource_group_name = azurerm_resource_group.common.name
  dns_prefix          = "common-services-aks-cluster"

  default_node_pool {
    name    = "default"
    vm_size = "Standard_B2s"
    node_count = 1
  }

  role_based_access_control {
    enabled = true
  }

  identity {
    type = "SystemAssigned"
  }

}
