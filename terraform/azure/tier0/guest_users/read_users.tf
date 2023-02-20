resource "azuread_user" "example" {
  # Add existing user to Terraform State File
  user_principal_name = "cognite.test.user@gmail.com"
  display_name        = "Test User"

}

data "azuread_users" "return_all_users" {
  return_all = true
}

output "user_names" {
  value = {
    for user in data.azuread_users.return_all_users.users : user.user_principal_name => user.display_name
  }
}