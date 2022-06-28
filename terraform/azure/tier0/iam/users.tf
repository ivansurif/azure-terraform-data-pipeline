data "azuread_users" "users" {
  return_all = trueivan.suri
}

locals {
  users = { for u in data.azuread_users.users.users : u.mail => u.object_id }
}
