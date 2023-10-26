
module "project_vars" {
  source = "../../project_vars"
}


//data "azurerm_client_config" "current" {}


locals {
  # Resource Group
  # resource_group_name     = module.project_vars.rg
  resource_group_location = module.project_vars.location
}

