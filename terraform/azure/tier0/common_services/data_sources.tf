module "project_vars" {
  source = "../../../project_vars"
}

data "azurerm_client_config" "current" {}


locals {

  # Resource Group
  resource_group_name     = "common-services"
  resource_group_location = module.project_vars.location
  # Resource Group
  resource_group_names_files_upload = [
    "files-upload-dev",
    "files-upload-test",
    "files-upload-prod"
  ]

  # Container Registry
  container_registry_name = "cogniteskfcenitregistry"
  container_registry_sku  = "Basic"

  # Key Vault
  key_vault_name = "cognite-skfcenit-kv"
  key_vault_sku  = "standard"

  # App Service Plan
  app_service_plan_name              = "cognite-skfcenit"
  app_service_plan_name_files_upload = "cognite-skfcenit-files-upload"
  app_service_plan_tier              = "PremiumV2"
  app_service_plan_size              = "P2v2"
  app_service_plan_kind              = "Linux"

  # Storage
  storage_name                        = "cogniteskfcenitmysandbox"
  storage_account_tier                = "Standard"
  storage_account_replication_type    = "LRS"
  storage_container_name_files_upload = "fileuploadstorage"
  storage_container_name_files_upload_prod_only = "fileuploadstorage-prod-only"
  storage_container_name_tags         = "cogniteskfcenittags"

  # AKS
  aks_cluster_name     = "cogniteskfcenit-aks"
  aks_cluster_location = module.project_vars.location



}