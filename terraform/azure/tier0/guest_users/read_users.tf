data "azuread_users" "example" {}

output "user_names" {
  value = {
    for user in data.azuread_users.example.users : user.user_principal_name => user.display_name
  }
}