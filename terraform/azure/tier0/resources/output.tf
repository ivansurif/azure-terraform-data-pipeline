data "azurerm_key_vault_secret" "test" {
  name         = "SAMPLE-SECRET"
  vault_uri    = "https://skfcenitdevtemp3.vault.azure.net/"
  key_vault_id = "skfcenitdevtemp3"
}


output "resource_group_id" {
  value = azurerm_resource_group.rg.id
}

output "resource_group_name" {
  value = azurerm_resource_group.rg.name
}

output "resource_group_location" {
  value = azurerm_resource_group.rg.location
}

output "sa_id" {
  value = azurerm_storage_account.storage.id
}

output "sa_name" {
  value = azurerm_storage_account.storage.name
}

output "sa_rep_type" {
  value = azurerm_storage_account.storage.account_replication_type
}

output "sa_tier" {
  value = azurerm_storage_account.storage.account_tier
}

output "primary_blob_endpoint" {
  value = azurerm_storage_account.storage.primary_blob_endpoint
}

output "key_vault_id" {
  value = azurerm_key_vault.kv.id
}

output "sample_secret_value" {
  value = data.azurerm_key_vault_secret.test.value
}
/*
output "blob_url" {
  value = azurerm_storage_blob.blob.url
}
*/