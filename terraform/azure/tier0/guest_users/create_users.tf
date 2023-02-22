#resource "azuread_user" "new_user" {
#  #Add existing user to Terraform State File
#  display_name = var.display_name
#  user_principal_name = var.user_principal_name
#  mail_nickname = var.mail_nickname
#  password = var.password
#  force_password_change = false
#  account_enabled = true
#}
locals {
  guest_users = {
    var.display_name : var.user_principal_name
    # ADD MORE USERS IS NECESSARY
  }
}


resource "azuread_invitation" "example" {
  for_each           = local.guest_users
  user_display_name  = each.key
  user_email_address = each.value
  redirect_url       = "https://portal.azure.com"

  message {
    body = "Hi, welcome to my Azure AD Tenant"
  }
}
