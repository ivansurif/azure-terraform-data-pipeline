locals {
  kv_set_members = [
    "ivan.surif@cognitedata.com",
  ]
}

resource "azuread_group" "kv_set" {
  display_name     = "common-services-kv-set"
  security_enabled = true

  members = [
    for user in local.kv_set_members : local.users[user]
  ]
}

