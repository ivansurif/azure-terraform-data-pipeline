resource "azuread_user" "example" {
  display_name = "Jane Doe"
  mail_nickname = "jane.doe"
  user_principal_name = "jane.doeddddd@gmail.com"
  password = "Password123!"
}

data "azuread_users" "return_all_users" {
  return_all = true
}

output "user_names" {
  value = {
    for user in data.azuread_users.return_all_users.users : user.user_principal_name => user.display_name
  }
}