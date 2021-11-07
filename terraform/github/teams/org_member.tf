# Add a user to the organization
resource "github_membership" "membership_for_noc" {
  for_each = local.user_map

  username = each.value.github_account
  role     = each.value.org_member
}