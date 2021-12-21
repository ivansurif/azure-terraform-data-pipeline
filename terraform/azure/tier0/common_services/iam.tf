locals {
  kv_set_members = [
      "scott.melhop@cognitedata.com"
  ]
}

resource "azuread_group" "kv_set" {
  display_name     = "common-services-kv-set"
  owners           = [data.azuread_client_config.current.object_id]
  security_enabled = true

  members = [
      for user in local.kv_set_members : local.users[user]
  ]
}

