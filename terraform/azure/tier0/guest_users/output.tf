#output "azuread_invitation" {
#  value = azuread_invitation.example
#}

output "all_users" {
  value = {
    for user in data.azuread_users.return_all_users_.users : user.object_id => user.display_name
  }
}

