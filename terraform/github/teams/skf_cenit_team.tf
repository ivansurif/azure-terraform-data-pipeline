resource "github_team" "skf_cenit_team_push" {
  name        = "skf-cenit-team-push"
  description = "SKF/Cenit external collaborators"
  privacy     = "closed"
}

resource "github_team_membership" "skf_cenit_team_push_membership" {
  for_each = { for k, v in local.github_users : k => v if contains(keys(v), "skf_cenit_team_push") }

  team_id  = github_team.skf_cenit_team_push.id
  username = local.github_users[each.key].github_account
  role     = local.github_users[each.key].skf_cenit_team_push
}

locals {
  skf_cenit_repos = [
    "terraform"
  ]
}

resource "github_team_repository" "skf_cenit_team_push_repos_membership" {
  for_each   = toset(local.skf_cenit_repos)
  team_id    = github_team.skf_cenit_team_push.id
  repository = each.value
  permission = "push"
}