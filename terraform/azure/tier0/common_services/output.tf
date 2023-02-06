output "storage_account" {
  description = "Storage account for Profiles"
  value       = azurerm_storage_account.storage.name
}

output "storage_account_share" {
  description = "Name of the Azure File Share created for FSLogix"
  value       = azurerm_storage_share.FSShare.name
}

output "AVD_user_groupname" {
  description = "Azure Active Directory Group for SMB Share users"
  value       = azuread_group.aad_group.display_name
}