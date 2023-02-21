resource "azuread_user" "new_user" {
  #Add existing user to Terraform State File
  display_name = var.display_name
  user_principal_name = var.user_principal_name
  mail_nickname = var.mail_nickname
  password = var.password
  force_password_change = false
  account_enabled = true
}