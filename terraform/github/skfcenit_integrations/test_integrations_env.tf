# resource "github_repository_environment" "test_environment" {
#   environment = "test-integrations"
#   repository  = data.github_repository.repo.name
#   reviewers {
#     teams = [data.github_team.infra_team.id]
#     users = [data.github_user.scott.id]
#   }
# }

# resource "github_actions_environment_secret" "test_site_creds_username" {
#   repository      = data.github_repository.repo.name
#   environment     = github_repository_environment.test_environment.environment
#   secret_name     = "USER_NAME"
#   plaintext_value = data.terraform_remote_state.integrations.outputs.site_credentials["skfcenit-integrations-test"][0]["username"]
# }

# resource "github_actions_environment_secret" "test_site_creds_password" {
#   repository      = data.github_repository.repo.name
#   environment     = github_repository_environment.test_environment.environment
#   secret_name     = "PASSWORD"
#   plaintext_value = data.terraform_remote_state.integrations.outputs.site_credentials["skfcenit-integrations-test"][0]["password"]
# }

# resource "github_actions_environment_secret" "test_site_creds_app_name" {
#   repository      = data.github_repository.repo.name
#   environment     = github_repository_environment.test_environment.environment
#   secret_name     = "APP_NAME"
#   plaintext_value = "skfcenit-integrations-test"
# }