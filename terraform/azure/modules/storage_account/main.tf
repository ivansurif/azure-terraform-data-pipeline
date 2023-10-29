resource "azurerm_storage_account" "az_sa" {
  name                     = var.storage_account_name
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

}


resource "azurerm_storage_queue" "az_saq" {
  name                  = var.storage_account_queue_name
  storage_account_name  = var.storage_account_name
}

