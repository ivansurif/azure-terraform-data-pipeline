resource "azurerm_eventgrid_event_subscription" "az_eventgrid_event_subscription" {
  name  = var.eventgrid_event_subscription_name
  scope = var.custom_topic_id

  # depends_on = [
  #   azurerm_storage_queue.az_saq,
  #   azurerm_eventgrid_topic.az_eventgrid_topic
  # ]

  storage_queue_endpoint {
    storage_account_id = var.storage_account_id
    queue_name         = var.queue_name
    }
}
