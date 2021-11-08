# Create a team
# resource "github_team" "team_example" {
#   name        = "test-team"
#   description = "Test Team creation"
#   privacy     = "closed"
# }

# Add a user member to a team
# resource "github_team_membership" "team_example_membership" {
#   for_each = { for k, v in local.user_map : k => v if contains(keys(v), "team_example") }

#   team_id  = github_team.team_example.id
#   username = local.user_map[each.key].github_account
#   role     = local.user_map[each.key].team_example
# }