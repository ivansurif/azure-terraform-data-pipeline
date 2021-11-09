# Note: If this resource group was created in Terraform, then this RBAC should exist within the same workspace

data "azurerm_resource_group" "skf_cenit_dev" {
  name = "skf-cenit-dev"
}

locals {
  user_access_admins = toset([
    "joel.sirefelt@cognitedata.com"
  ])
}

resource "azurerm_role_assignment" "skf_cenit_dev_user_access_admin" {
  for_each = local.user_access_admins
  scope                = data.azurerm_resource_group.skf_cenit_dev.id
  role_definition_name = "User Access Administrator"
  principal_id         = local.users[each.value]
}