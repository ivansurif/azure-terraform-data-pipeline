locals {
  kv_set_members = [
    "cognite.test.user@gmail.com",
  ]
}

resource "azuread_group" "kv_set" {
  display_name     = "common-services-kv-set"
  security_enabled = true

  members = [
    for user in local.kv_set_members : local.users[user]
  ]
}

