data "azuread_user" "example_users" {
  count = null
}

output "user_display_names" {
  value = [for user in data.azuread_user.example_users : user.display_name]
}
