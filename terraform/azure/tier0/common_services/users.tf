data "azuread_users" "users" {
  return_all = true
}

locals {
/* Replaced with hardcoded users to avoid
Error: Duplicate object key
Two different items produced the key "" in this 'for' expression
This affects Cognite USA Sandbox environment only
Restore for loop for other environments
*/
#  users = { for u in data.azuread_users.users.users : u.mail => u.object_id}
  users =
  {
    "ivan.surif@cognitedata.com" = "8bdf19e5-b72a-4ed8-904d-fdb6d5a0e0b3"
  }
}
