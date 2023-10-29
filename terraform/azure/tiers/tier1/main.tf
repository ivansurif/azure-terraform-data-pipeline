module "event_grid" {
  source = "../../modules/event_grid"
  resource_group_name = var.resource_group_name
  location = var.location
  custom_topic_name = var.custom_topic_name
}

module "storage_account" {
  source = "../../modules/storage_account"
  resource_group_name = var.resource_group_name
  location = var.location
  storage_account_name = var.storage_account_name
  storage_account_queue_name = var.storage_account_queue_name
}