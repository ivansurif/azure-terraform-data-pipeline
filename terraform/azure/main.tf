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


module "tier0_foundational" {
  source             = "./tiers/tier0_foundational"
  resource_group_name= var.resource_group_name
  resource_group_location = var.resource_group_location
}

# Uncomment when module is creataed
# module "tier1_core" {
#   source             = "./tiers/tier1_core"
#   # ... pass other necessary variables
# }

