output "custom_topic_id" {
  value = module.event_grid.custom_topic_id
}

output "storage_account_id" {
  value = module.storage_account.storage_account_id
}

output "queue_name" {
  value = module.storage_account.queue_name
}