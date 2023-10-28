module "event_grid" {
  source = "../../modules/event_grid"
  resource_group_name = var.resource_group_name
  resource_group_location = var.resource_group_location
  custom_topic_name = var.custom_topic_name
}