
module "project_vars" {
  source = "../../project_vars"
}

module "guest_users" {
  source = "../guest_users"
}

//data "azurerm_client_config" "current" {}


locals {

  # Resource Group
  resource_group_name     = "common_services"
  resource_group_location = module.project_vars.location
}

