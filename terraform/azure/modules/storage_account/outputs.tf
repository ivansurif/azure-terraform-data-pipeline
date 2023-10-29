output "storage_account_id" {
  value = azurerm_storage_account.az_sa.id
}

output "queue_name" {
  value = azurerm_storage_queue.az_saq.name
}