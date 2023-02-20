#resource "azuread_user" "example" {
# Add existing user to Terraform State File
#  user_principal_name = "cognite.test.user_gmail.com#EXT#@ivansurifgmail.onmicrosoft.com"
#  display_name        = "Test User"
#
#}

data "azuread_users" "return_all_users" {
  return_all = true
}


resource "azuread_user" "user" {
  for_each = { for user in data.azuread_users.return_all_users.users : user.object_id => user }

  user_principal_name = each.value.user_principal_name
  display_name        = each.value.display_name
  mail_nickname       = each.value.mail_nickname
  account_enabled     = each.value.account_enabled
}