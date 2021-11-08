# Create a team
# resource "github_team" "team_test" {
#   name        = "test-team"
#   description = "Test Team creation"
#   privacy     = "closed"
# }

# Add a user member to a team
# resource "github_team_membership" "team_noc_employee_write_membership" {
#   for_each = { for k, v in local.cognite_noc_user_map : k => v if contains(keys(v), "team_noc_employee_write") }

#   team_id  = github_team.team_noc_employee_write.id
#   username = local.cognite_noc_user_map[each.key].github_account
#   role     = local.cognite_noc_user_map[each.key].team_noc_employee_write
# }