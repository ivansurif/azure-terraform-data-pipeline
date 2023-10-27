# generate a random string (consisting of four characters)
# https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/string
resource "random_string" "random" {
  length  = 4
  upper   = false
  special = false
}

## Azure Storage Accounts requires a globally unique names
## https://docs.microsoft.com/en-us/azure/storage/common/storage-account-overview
## Create a Storage Account
resource "azurerm_storage_account" "storage" {
  name                     = "stor${random_string.random.id}"
  resource_group_name      = azurerm_resource_group.common.name
  location                 = azurerm_resource_group.common.location
  account_tier             = "Premium" # TODO: CHANGE THIS
  account_replication_type = "LRS" # TODO: CHANGE THIS
  account_kind             = "FileStorage" # TODO: CHANGE THIS
}