resource "github_team" "infra_team_push" {
  name        = "test-team"
  description = "Test Team creation"
  privacy     = "closed"
}

resource "github_team_membership" "infra_team_push_membership" {
  for_each = { for k, v in local.github_users : k => v if contains(keys(v), "infra_team_push") }

  team_id  = github_team.infra_team_push.id
  username = local.github_users[each.key].github_account
  role     = local.github_users[each.key].infra_team_push
}

locals {
  infra_repos = [
    "terraform"
  ]
}

resource "github_team_repository" "infra_team_push_repos_membership" {
  for_each   = toset(local.infra_repos)
  team_id    = github_team.infra_team_push
  repository = each.value
  permission = "push"
}