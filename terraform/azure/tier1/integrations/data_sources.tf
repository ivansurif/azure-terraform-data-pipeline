module "project_vars" {
  source = "../../../project_vars"
}

data "azurerm_client_config" "current" {}

data "terraform_remote_state" "common_services" {
  backend = "azurerm"

  config = {
    storage_account_name = "cogniteskfcenittf"
    container_name       = "tfstate"
    key                  = "azure.tier0.common_services"

    # Access Key set as environment variable ARM_ACCESS_KEY

  }
}

locals {

  # Resource Group
  resource_group_name     = "integration-functions"
  resource_group_location = data.terraform_remote_state.common_services.outputs.resource_group_location
  # storage
  storage_account_name    = data.terraform_remote_state.common_services.outputs.storage_account_name
  primary_blob_endpoint   = data.terraform_remote_state.common_services.outputs.storage_account_primary_blob_endpoint
  primary_blob_access_key = data.terraform_remote_state.common_services.outputs.storage_account_primary_access_key
  sas_url                 = "${local.primary_blob_endpoint}${local.primary_blob_access_key}"

  key_vault_name = data.terraform_remote_state.common_services.outputs.key_vault_name
  key_vault_id   = data.terraform_remote_state.common_services.outputs.key_vault_id

  function_apps = {
    "skfcenit-integrations-test" = {
      app_service_plan = data.terraform_remote_state.common_services.outputs.app_service_plan_name
      app_settings = {
        API_URL                  = "https://transportecenit.azurefd.net/digitalt/api/v1/points"
        SYSTEM_GUID              = "0c801d9c-5142-4fd0-b50d-34e3e5aa5815"
        CDF_CLIENT_ID            = "182226d3-ae9f-4c39-8a0c-ee9bd43f0d48"
        CDF_TENANT_ID            = data.azurerm_client_config.current.tenant_id
        CDF_CLUSTER              = "az-eastus-1"
        CDF_COGNITE_PROJECT      = "skfcenit-test"
        WEBSITE_RUN_FROM_PACKAGE = "1"
        FUNCTIONS_WORKER_RUNTIME = "python"
      }
      secrets = {
        CDF_CLIENT_SECRET = "CDF-CLIENT-SECRET"
        API_KEY           = "API-KEY"
      }
      always_on        = false
      https_only       = true
      linux_fx_version = "Python|3.9"
    }
  }
}

