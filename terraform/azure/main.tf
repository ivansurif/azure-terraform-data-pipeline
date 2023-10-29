# module "tier0_foundational" {
#   source              = "./modules/tier0_foundational"
#   resource_group_name = var.resource_group_name
#   location            = var.resource_group_location
# }

# Uncomment when module is creataed
# module "tier1_core" {
#   source              = "./modules/tier1_core"
#   resource_group_name = module.tier0_foundational.resource_group_name
#   // ... other variables as required
# }


module "tier0" {
  source             = "./tiers/tier0"
  resource_group_name= var.resource_group_name
  resource_group_location = var.resource_group_location
}

module "tier1" {
  source             = "./tiers/tier1"
  resource_group_name = module.tier0.resource_group_name
  location = module.tier0.resource_group_location
  custom_topic_name = var.custom_topic_name
  storage_account_name = var.storage_account_name
  storage_account_queue_name = var.storage_account_queue_name
  depends_on = [module.tier0]
}

module "tier2" {
  source = "./tiers/tier2"
  eventgrid_event_subscription_name = var.eventgrid_event_subscription_name
  depends_on = [module.tier1]
  custom_topic_id = module.tier1.custom_topic_id
  storage_account_id = module.tier1.storage_account_id
  queue_name = module.tier1.queue_name
}

