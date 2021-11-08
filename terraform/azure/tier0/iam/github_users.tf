data "azuread_service_principal" "github_enterprise" {
  display_name = "GitHub Enterprise Cloud - Organization"
}

locals {
  app_roles = {for v in data.azuread_service_principal.github_enterprise.app_roles : v.display_name => v.id}
  
}

resource "azuread_app_role_assignment" "example" {
  for_each = module.project_vars.github_users
  app_role_id         = local.app_roles["User"]
  principal_object_id = local.users[each.key]
  resource_object_id  = data.azuread_service_principal.github_enterprise.object_id
}
