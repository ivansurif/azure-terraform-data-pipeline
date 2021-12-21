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
  resource_group_name     = "vessel-supply-service-az-function"
  resource_group_location = data.terraform_remote_state.common_services.outputs.common_services_location
  # storage
  storage_account_name    = data.terraform_remote_state.common_services.outputs.storage_account_name
  primary_blob_endpoint   = data.terraform_remote_state.common_services.outputs.storage_account_primary_blob_endpoint
  primary_blob_access_key = data.terraform_remote_state.common_services.outputs.storage_account_primary_access_key
  sas_url                 = "${local.primary_blob_endpoint}${local.primary_blob_access_key}"

  cdf_cluster    = "westeurope-1"
  idp_tenant_id  = "3aa4a235-b6e2-48d5-9195-7fcf05b459b0" // Equinor's AAD
  key_vault_name = data.terraform_remote_state.common_services.outputs.common_service_key_vault_name
  key_vault_id   = data.terraform_remote_state.common_services.outputs.common_service_key_vault_id

  function_apps = {
    "vessel-supply-service-az-function-test" = {
      app_service_plan = "trading-app-services"
      app_settings = {
        "DOCKER_REGISTRY_SERVER_URL"      = "https://${data.terraform_remote_state.common_services.outputs.container_registry_login_server}"
        "DOCKER_REGISTRY_SERVER_USERNAME" = data.terraform_remote_state.common_services.outputs.container_registry_admin_username
        "DOCKER_REGISTRY_SERVER_PASSWORD" = data.terraform_remote_state.common_services.outputs.container_registry_admin_password
        "LOGGING_LEVEL"                   = "INFO"

        "WEBSITES_ENABLE_APP_SERVICE_STORAGE" = false
      }
      secrets = {
        CDF_CLIENT_ID           = "CDF-TEST-ALLPROJECTS-CLIENT-ID"
        CDF_CLIENT_SECRET       = "CDF-TEST-ALLPROJECTS-CLIENT-SECRET"
        SIGNAL_TONNAGE_API_KEY  = "SIGNAL-TONNAGE-API-KEY"
        SIGNAL_DISTANCE_API_KEY = "SIGNAL-DISTANCE-API-KEY"
      }
      always_on  = true
      https_only = true
      # linux_fx_version = "DOCKER|cogniteequinortrading.azurecr.io/vessel-supply:test-latest"
    },
    "vessel-supply-service-az-function-dev" = {
      app_service_plan = "trading-app-services"
      app_settings = {
        "DOCKER_REGISTRY_SERVER_URL"      = "https://${data.terraform_remote_state.common_services.outputs.container_registry_login_server}"
        "DOCKER_REGISTRY_SERVER_USERNAME" = data.terraform_remote_state.common_services.outputs.container_registry_admin_username
        "DOCKER_REGISTRY_SERVER_PASSWORD" = data.terraform_remote_state.common_services.outputs.container_registry_admin_password
        "LOGGING_LEVEL"                   = "INFO"

        "WEBSITES_ENABLE_APP_SERVICE_STORAGE" = false
        "https_only"                          = true
      }
      secrets = {
        CDF_CLIENT_ID           = "CDF-DEV-ALLPROJECTS-CLIENT-ID"
        CDF_CLIENT_SECRET       = "CDF-DEV-ALLPROJECTS-CLIENT-SECRET"
        SIGNAL_TONNAGE_API_KEY  = "SIGNAL-TONNAGE-API-KEY"
        SIGNAL_DISTANCE_API_KEY = "SIGNAL-DISTANCE-API-KEY"
      }
      always_on  = true
      https_only = true
      # linux_fx_version = "DOCKER|cogniteequinortrading.azurecr.io/vessel-supply:latest"
    }
  }


  # slots = {
  #   "equinor-shipping-plotly-dash-web-app" = "staging"
  # }
}

