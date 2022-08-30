data "azuread_service_principal" "github_enterprise" {
  display_name = "ivan-industries-at-usa-sandbox"
}

locals {
  app_roles = { for v in data.azuread_service_principal.github_enterprise.app_roles : v.display_name => v.id }
  github_users = [
    "ivan.surif@cognitedata.com"
  ]

}

output app_roles{
    value = local.app_roles
}

/*
resource "azuread_app_role_assignment" "github_sso" {
  for_each            = toset(local.github_users)
  app_role_id         = local.app_roles["User"]
  principal_object_id = local.users[each.key]
  resource_object_id  = data.azuread_service_principal.github_enterprise.object_id
}
*/