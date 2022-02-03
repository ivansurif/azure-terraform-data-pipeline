resource "azuread_directory_role" "app_admin" {
  display_name = "Application administrator"
}

locals {
  app_admins = toset([
    "joel.sirefelt@cognitedata.com",
    "ivan.surif@cognitedata.com"
  ])
}

resource "azuread_directory_role_member" "app_admin_members" {
  for_each         = local.app_admins
  role_object_id   = azuread_directory_role.app_admin.object_id
  member_object_id = local.users[each.value]
}
