module "event_grid_subscription" {
  source = "../../modules/eg_subscription"
  eventgrid_event_subscription_name = var.eventgrid_event_subscription_name
  custom_topic_id = var.custom_topic_id
  storage_account_id = var.storage_account_id
  queue_name = var.queue_name
}