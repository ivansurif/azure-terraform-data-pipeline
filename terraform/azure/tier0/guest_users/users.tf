locals {
  guest_users = {
    "TEST GMAIL USER" : "cognite.test.user@gmail.com",
  }
}

resource "azuread_invitation" "example" {
  for_each           = local.guest_users
  user_display_name  = each.key
  user_email_address = each.value
  redirect_url       = "https://portal.azure.com"

  message {
    body = "Hi, welcome to Cognite - SKF Cenit Azure AD Tenant"
  }
}
