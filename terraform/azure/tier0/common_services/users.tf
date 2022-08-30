data "azuread_users" "users" {
  return_all = true
}

locals {
  users = { for u in data.azuread_users.users.users : u.mail => u.object_id
    #if u.mail != ""
  if u.mail == "cognite.test.user@gmail.com" }
}
