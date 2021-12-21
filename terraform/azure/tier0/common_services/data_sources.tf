module "project_vars" {
  source = "../../../project_vars"
}

data "azurerm_client_config" "current" {}


locals {

  # Resource Group
  resource_group_name     = "common-services"
  resource_group_location = module.project_vars.location

  # Container Registry
  container_registry_name = "cogniteskfcenit"
  container_registry_sku  = "Basic"

  # Key Vault
  key_vault_name = "cognite-skfcenit-kv"
  key_vault_sku  = "standard"

  # App Service Plan
  app_service_plan_name = "cognite-skfcenit"
  app_service_plan_tier = "PremiumV2"
  app_service_plan_size = "P2v2"
  app_service_plan_kind = "Linux"

  # Storage
  storage_name                     = "cogniteskfcenitcommon"
  storage_account_tier             = "Standard"
  storage_account_replication_type = "LRS"

}