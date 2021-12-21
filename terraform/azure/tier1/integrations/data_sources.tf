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
  resource_group_names = [
    "integration-functions-dev",
    "integration-functions-test",
    "integration-functions-prod"
  ]
  resource_group_location = data.terraform_remote_state.common_services.outputs.resource_group_location
  # storage
  storage_account_name    = data.terraform_remote_state.common_services.outputs.storage_account_name
  primary_blob_endpoint   = data.terraform_remote_state.common_services.outputs.storage_account_primary_blob_endpoint
  primary_blob_access_key = data.terraform_remote_state.common_services.outputs.storage_account_primary_access_key
  sas_url                 = "${local.primary_blob_endpoint}${local.primary_blob_access_key}"

  key_vault_name = data.terraform_remote_state.common_services.outputs.key_vault_name
  key_vault_id   = data.terraform_remote_state.common_services.outputs.key_vault_id

  common_app_settings = {
    WEBSITE_RUN_FROM_PACKAGE = "1"
    FUNCTIONS_WORKER_RUNTIME = "python"
    CDF_CLUSTER              = "az-eastus-1"
    CDF_TENANT_ID            = "83a6ef4c-74d8-4858-9728-4faa19df8bc6"
    API_URL                  = "https://transportecenit.azurefd.net/digitalt/api/v1/points"
  }

  common_secrets = {
    API_KEY = "API-KEY"
  }

  environments = {
    dev = {
      resource_group_name = "integration-functions-dev"
      app_settings = {
        CDF_CLIENT_ID       = "77980a5e-35f7-4692-a401-14f3b30401a4"
        CDF_COGNITE_PROJECT = "skfcenit-dev"
      }
      secrets = {
        CDF_CLIENT_SECRET = "CDF-CLIENT-SECRET-DEV"
      }
    }

    test = {
      resource_group_name = "integration-functions-test"
      app_settings = {
        CDF_CLIENT_ID       = "182226d3-ae9f-4c39-8a0c-ee9bd43f0d48"
        CDF_COGNITE_PROJECT = "skfcenit-test"
      }
      secrets = {
        CDF_CLIENT_SECRET = "CDF-CLIENT-SECRET-TEST"
      }
    }

    prod = {
      resource_group_name = "integration-functions-prod"
      app_settings = {
        CDF_CLIENT_ID       = "c3b95ff9-f014-4a92-a113-5b2e135c5beb"
        CDF_COGNITE_PROJECT = "skfcenit"
      }
      secrets = {
        CDF_CLIENT_SECRET = "CDF-CLIENT-SECRET-PROD"
      }
    }
  }
  system_guids = {
    Cpy = "b7805d9a-f501-45e6-91bf-3c9c062c664d"
    Aya = "9ad2aaf3-b305-49e2-bbf6-947a981cb03c"
    Poz = "0c801d9c-5142-4fd0-b50d-34e3e5aa5815"
  }

  apps = flatten([
    for system in keys(local.system_guids) : [
      for environment in keys(local.environments) : {
        system      = system
        environment = environment
      }
    ]
  ])

  function_apps = {
    for app in local.apps :
    "skfcenit-integrations-${app["system"]}-${app["environment"]}" => {
      app_service_plan    = data.terraform_remote_state.common_services.outputs.app_service_plan_name
      app_settings        = merge(local.environments[app["environment"]]["app_settings"], local.common_app_settings)
      secrets             = merge(local.environments[app["environment"]]["secrets"], local.common_secrets)
      always_on           = false
      https_only          = true
      linux_fx_version    = "Python|3.9"
      resource_group_name = local.environments[app["environment"]]["resource_group_name"]
    }
  }
}
