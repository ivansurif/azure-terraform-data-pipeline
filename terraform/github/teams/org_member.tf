# Add a user to the organization
resource "github_membership" "org_membership" {
  for_each = module.project_vars.github_users

  username = each.value.github_account
  role     = each.value.org_member
}