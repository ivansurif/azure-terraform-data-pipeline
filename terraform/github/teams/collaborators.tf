resource "github_repository_collaborator" "terraform_repo_admin" {
  repository = "terraform"
  username   = "ivansurif"
  permission = "admin"
}

resource "github_repository_collaborator" "terraform_repo_pusher" {
  repository = "terraform"
  username   = "gognite-test-user"
  permission = "push"
}