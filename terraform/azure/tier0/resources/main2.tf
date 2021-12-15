data "azurerm_client_config" "current" {
}

locals {
  new_resource_name = "skfcenitdevtemp5"
}

data "azurerm_key_vault" "example" {
  name                = local.new_resource_name
  resource_group_name = azurerm_resource_group.rg.name
}

output "vault_uri" {
  value = data.azurerm_key_vault.example.vault_uri
}

# Reading secret value after access policy is set
data "azurerm_key_vault_secret" "test" {
  name         = "SAMPLE-SECRET"
  key_vault_id = data.azurerm_key_vault.example.id
  depends_on = [
    azurerm_key_vault_access_policy.kv_ap
  ]
}


resource "azurerm_resource_group" "rg" {
  name     = local.new_resource_name
  location = var.location
}

resource "azurerm_key_vault" "kv" {
  name                        = local.new_resource_name
  location                    = azurerm_resource_group.rg.location
  resource_group_name         = azurerm_resource_group.rg.name
  enabled_for_disk_encryption = true
  sku_name                    = "standard"
  tenant_id                   = data.azurerm_client_config.current.tenant_id

  soft_delete_retention_days = 7
  purge_protection_enabled   = false

}


resource "azurerm_key_vault_access_policy" "kv_ap" {
  key_vault_id = azurerm_key_vault.kv.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = data.azurerm_client_config.current.object_id

  key_permissions = [
    "Get",
    "Create",
    "List"
  ]

  secret_permissions = [
    "Get",
    "Set",
    "List"
  ]

  storage_permissions = [
    "Get",
    "Set"
  ]
}


resource "azurerm_key_vault_secret" "acg_username" {
  name         = "imageregistryusername"
  value        = "username"
  key_vault_id = azurerm_key_vault.kv.id
  depends_on = [
    azurerm_key_vault_access_policy.kv_ap
  ]
}

resource "azurerm_key_vault_secret" "acg_secret" {
  name         = "imageregistrysecret"
  value        = "secret"
  key_vault_id = azurerm_key_vault.kv.id
  depends_on = [
    azurerm_key_vault_access_policy.kv_ap
  ]
}

# Setting secret value after access policy is set
resource "azurerm_key_vault_secret" "sample_secret_test" {
  name         = "SAMPLE-SECRET"
  value        = var.SAMPLE_SECRET
  key_vault_id = azurerm_key_vault.kv.id
  depends_on = [
    azurerm_key_vault_access_policy.kv_ap
  ]
}

# Creating new storage account, for the one referenced in providers
# is solely used to save state

resource "azurerm_storage_account" "storage" {
  account_replication_type = "LRS"
  account_tier             = "Standard"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  # for testing purposes> SA name will be set from KV secret
  # name                     = local.new_resource_name
  name                     = data.azurerm_key_vault_secret.test.value
  allow_blob_public_access = true
  depends_on = [
    azurerm_key_vault_access_policy.kv_ap
  ]
}


/*
CONTAINER REGISTRY
*/
resource "azurerm_container_registry" "acr" {
  name                = local.new_resource_name
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  sku                 = "Basic"
  admin_enabled       = true


}


/*
CONTAINER INSTANCE
*/

/*
resource "azurerm_storage_container" "container" {
  name                 = var.storage_container_name
  storage_account_name = azurerm_storage_account.storage.name
  container_access_type = "container" # "blob" "private"
}
*/

# See https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/container_group





/* USE BELOW CODE TO UPLOAD BLOB "MANUALLY" TO STORAGE CONTAINER:
resource "azurerm_storage_blob" "blob" {
  name                   = "sample-file.sh"
  storage_account_name   = azurerm_storage_account.storage.name
  storage_container_name = azurerm_storage_container.container.name
  type                   = "Block"
  BLOB TYPE CAN BE DIFFERENT THAN BLOCK
  source                 = "sample_file.txt"
}
*/

# PENDING ACCESSIBILITY MANAGEMENT
# (container_access_type and allow_blob_public_access)

#### PASTED APP FILE BELOW


resource "azurerm_container_group" "acg" {
  name                = local.new_resource_name
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  ip_address_type     = "public"
  os_type             = "Linux"

  image_registry_credential {
    # An Azure Container Registry from the current subscription
    server   = var.server
    username = "sample_username" # ===>>>> PLACEHOLDER; WILL NEED TO READ FROM KV
    password = "sample_password" # ===>>>> PLACEHOLDER; WILL NEED TO READ FROM KV
  }

  container {
    name = local.new_resource_name
    # The name of the Azure Container Instances resource.
    # This will be its identifier in Azure and can be different from the image name.
    # Changing this forces a new resource to be created.
    image  = "crskf.azurecr.io/diskf01:ver2" # ===>>>> MAKE DYNAMIC
    cpu    = "0.5"
    memory = "1.5"

    ports {
      port     = 443
      protocol = "TCP"
    }
  }
}


resource "azurerm_application_insights" "func_application_insights" {
  name                = local.new_resource_name
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  application_type    = "Node.JS"
}


resource "azurerm_app_service_plan" "func_app_service_plan" {
  name                = local.new_resource_name
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  kind                = "FunctionApp" # ===>>> research if Linux instead
  reserved            = true
  sku {
    tier = "Dynamic"
    size = "Y1"
  }

}

resource "azurerm_function_app" "func_function_app" {
  name                       = local.new_resource_name
  location                   = azurerm_resource_group.rg.location
  resource_group_name        = azurerm_resource_group.rg.name
  app_service_plan_id        = azurerm_app_service_plan.func_app_service_plan.id
  os_type                    = "linux"
  storage_account_name       = azurerm_storage_account.storage.name
  storage_account_access_key = azurerm_storage_account.storage.primary_access_key
  version                    = "~3"
  identity {
    type = "SystemAssigned"
  }

  site_config {
    linux_fx_version          = "PYTHON|3.9"
    use_32_bit_worker_process = false
  }

  app_settings = {
    APPINSIGHTS_INSTRUMENTATIONKEY = azurerm_application_insights.func_application_insights.instrumentation_key,
    API_URL                        = "https://transportecenit.azurefd.net/digitalt/api/v1/points"
    SYSTEM_GUID                    = "0c801d9c-5142-4fd0-b50d-34e3e5aa5815"
    CDF_CLIENT_ID                  = "182226d3-ae9f-4c39-8a0c-ee9bd43f0d48"
    CDF_TENANT_ID                  = data.azurerm_client_config.current.tenant_id
    CDF_CLUSTER                    = "az-eastus-1"
    CDF_COGNITE_PROJECT            = "skfcenit-test"
    # CDF_COGNITE_PROJECT             = "skfcenit-dev"
    CDF_CLIENT_SECRET = "@Microsoft.KeyVault(SecretUri=https://testenvtemp.vault.azure.net/secrets/CDF-CLIENT-SECRET/630dabdc44ec4833ab6d26a476869aa4)"
    API_KEY           = "@Microsoft.KeyVault(SecretUri=https://testenvtemp.vault.azure.net/secrets/API-KEY/fdd554c6f4984ba6903fcbffbe59ab87)"
  }
}

/*
output "sample_secret_value" {
  # marking value as nonsensitive for testing purposes, for this is a test secret I'll be exposing
  # DO NOT USES nonsensitive otherwise
  value = nonsensitive(data.azurerm_key_vault_secret.test.value)
}
*/


