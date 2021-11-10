locals {
  guest_users = {
    "Håkon Treider" : "hakon.treider@cognitedata.com",
    "Kelvin Sundli" : "kelvin.sundli@cognitedata.com",
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