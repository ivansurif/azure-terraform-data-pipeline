resource "github_repository_collaborator" "terraform_repo_admin" {
  repository = "terraform"
  username   = "ivansurif"
  permission = "admin"
}

resource "github_repository_collaborator" "terraform_repo_pusher" {
  for_each = local.external_collaborators
  repository = "terraform"
  username = each.value.github_account
  permission = "push"
}

resource "github_repository_collaborator" "hist_repo_pusher" {
  for_each = local.external_collaborators
  repository = "hist-integrations"
  username = each.value.github_account
  permission = "push"
}

resource "github_repository_collaborator" "RT_repo_pusher" {
  for_each = local.external_collaborators
  repository = "real-time-integrations"
  username = each.value.github_account
  permission = "push"
}

resource "github_repository_collaborator" "transformations_repo_pusher" {
  for_each = local.external_collaborators
  repository = "transformations"
  username = each.value.github_account
  permission = "push"
}




