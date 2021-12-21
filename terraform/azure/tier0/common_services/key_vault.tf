

resource "azurerm_key_vault" "key_vault" {
  name                        = local.key_vault_name
  location                    = azurerm_resource_group.common.location
  resource_group_name         = azurerm_resource_group.common.name
  enabled_for_disk_encryption = true
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days  = 7
  purge_protection_enabled    = false

  sku_name = local.key_vault_sku
}

resource "azurerm_key_vault_access_policy" "kv_ap" {
  key_vault_id = azurerm_key_vault.key_vault.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = data.azurerm_client_config.current.object_id

  secret_permissions = [
    "Get",
    "Set",
    "List",
    "Delete",
    "Purge",
    "Recover"
  ]
}