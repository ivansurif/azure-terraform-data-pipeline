#resource "azuread_user" "example" {
  # Add existing user to Terraform State File
#  user_principal_name = "cognite.test.user_gmail.com#EXT#@ivansurifgmail.onmicrosoft.com"
#  display_name        = "Test User"
#
#}

data "azuread_users" "return_all_users" {
  return_all = true
}