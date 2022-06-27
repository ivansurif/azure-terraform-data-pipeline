module "project_vars" {
  source = "../../../project_vars"
}

data "azurerm_client_config" "current" {}

data "terraform_remote_state" "common_services" {
  backend = "azurerm"

  config = {
    storage_account_name = "skfcenittf"
    container_name       = "tfstate"
    key                  = "azure.tier0.common_services"

    # Access Key set as environment variable ARM_ACCESS_KEY

  }
}

locals {

  # Resource Group.
  resource_group_names = [
    "integration-functions-dev",
    "integration-functions-test",
    "integration-functions-prod"
  ]

  # Resource Groups for files upload functions are created in Tier 0
  resource_group_names_files_upload = [
    data.terraform_remote_state.common_services.outputs.resource_group_name_files_upload_dev,
    data.terraform_remote_state.common_services.outputs.resource_group_name_files_upload_test,
    data.terraform_remote_state.common_services.outputs.resource_group_name_files_upload_prod
  ]

  # Insights Instrumentation keys
  insight_instrumentation_keys_files_upload = {
    files-upload-dev  = data.terraform_remote_state.common_services.outputs.insights_instrumentation_key_files_upload_dev,
    files-upload-test = data.terraform_remote_state.common_services.outputs.insights_instrumentation_key_files_upload_test,
    files-upload-prod = data.terraform_remote_state.common_services.outputs.insights_instrumentation_key_files_upload_prod,
  }


  resource_group_location = data.terraform_remote_state.common_services.outputs.resource_group_location
  # storage
  storage_account_name    = data.terraform_remote_state.common_services.outputs.storage_account_name
  primary_blob_endpoint   = data.terraform_remote_state.common_services.outputs.storage_account_primary_blob_endpoint
  primary_blob_access_key = data.terraform_remote_state.common_services.outputs.storage_account_primary_access_key
  sas_url                 = "${local.primary_blob_endpoint}${local.primary_blob_access_key}"

  key_vault_name = data.terraform_remote_state.common_services.outputs.key_vault_name
  key_vault_id   = data.terraform_remote_state.common_services.outputs.key_vault_id

  common_app_settings = {
    WEBSITE_RUN_FROM_PACKAGE       = "1"
    FUNCTIONS_WORKER_RUNTIME       = "python"
    CDF_CLUSTER                    = "az-eastus-1"
    CDF_TENANT_ID                  = "83a6ef4c-74d8-4858-9728-4faa19df8bc6"
    API_URL                        = "https://transportecenit.azurefd.net/digitalt/api/v1/points"
    SCM_DO_BUILD_DURING_DEPLOYMENT = false
    ENABLE_ORYX_BUILD              = false
  }

  common_secrets = {
    API_KEY = "API-KEY"
  }

  environments = {
    dev = {
      resource_group_name = "integration-functions-dev"
      resource_group_name_files_upload = data.terraform_remote_state.common_services.outputs.resource_group_name_files_upload_dev
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
      resource_group_name_files_upload = data.terraform_remote_state.common_services.outputs.resource_group_name_files_upload_test
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
      resource_group_name_files_upload = data.terraform_remote_state.common_services.outputs.resource_group_name_files_upload_prod
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
    Car = "43c6892d-56c8-43ba-a883-655e922bb5ca"
    Alb = "2b920ed6-c316-40ba-b3ab-72ba2f7e193a"
    Vil = "72bfbb64-2428-4112-bba2-a6d8fd32a965"
    Med = "b55a6fa2-b907-4bd0-9456-91078f99dc87"
    Ara = "3455d2c3-cf38-4f45-b8f9-1f04d8418b09"
    Sfd = "5282b1b6-d17b-4004-92b5-421b8e7c2a15"
    San = "6d0396f7-4f42-4073-b21b-c379b41e5f01"
    Crs = "a09850f9-6492-4a60-b384-40e57469491e"
    Mon = "9750a304-3c7d-4e4f-8146-840875d21f16"
  }

  apps = flatten([
    for system in keys(local.system_guids) : [
      for environment in keys(local.environments) : {
        system      = system
        environment = environment
      }
    ]
  ])

  apps_files_upload = flatten([
    for environment in keys(local.environments) : {
      environment = environment
    }
    ]
  )


  function_apps = {
    for app in local.apps :
    "skfcenit-integrations-${app["system"]}-${app["environment"]}" => {
      app_service_plan    = data.terraform_remote_state.common_services.outputs.app_service_plan_name
      app_settings        = merge(local.environments[app["environment"]]["app_settings"], local.common_app_settings, { SYSTEM_GUID = local.system_guids[app["system"]] })
      secrets             = merge(local.environments[app["environment"]]["secrets"], local.common_secrets)
      always_on           = "true"
      https_only          = true
      linux_fx_version    = "Python|3.9"
      resource_group_name = local.environments[app["environment"]]["resource_group_name"]
    }
  }

  alerts = {
    for app in local.apps :
    "alert-${app["system"]}-${app["environment"]}" => {
      query = <<-QUERY
      traces
      | where message contains "Successfully uploaded datapoints to CDF"
      | where cloud_RoleName =~ 'skfcenit-integrations-${app["system"]}-${app["environment"]}' and operation_Name  =~ 'update_datapoints'
      QUERY
    }
  }


  function_apps_files_upload = {
    for app in local.apps_files_upload :
    "files-upload-${app["environment"]}" => {
      app_service_plan    = data.terraform_remote_state.common_services.outputs.app_service_plan_name_files_upload
      app_settings        = merge(local.environments[app["environment"]]["app_settings"], local.common_app_settings)
      secrets             = merge(local.environments[app["environment"]]["secrets"], local.common_secrets)
      always_on           = false
      https_only          = true
      linux_fx_version    = "Python|3.9"
      resource_group_name = local.environments[app["environment"]]["resource_group_name_files_upload"]
    }
  }

  function_apps_skf_ai_data = {
    for app in local.apps_files_upload :
    "skf-ai-data-${app["environment"]}" => {
      app_service_plan    = data.terraform_remote_state.common_services.outputs.app_service_plan_name_files_upload
      app_settings        = merge(local.environments[app["environment"]]["app_settings"], local.common_app_settings, {URL_TOPIC = "https://transportecenit.azurefd.net/ub/api/events"})
      secrets             = merge(local.environments[app["environment"]]["secrets"], {TOPIC_ACCESS_KEY = "TOPIC-ACCESS-KEY"})
      always_on           = false
      https_only          = true
      linux_fx_version    = "Python|3.9"
      resource_group_name = local.environments[app["environment"]]["resource_group_name_files_upload"]
    }
  }
}

