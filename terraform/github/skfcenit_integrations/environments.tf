locals {
  environments = {
    dev = {
      teams = []
      users = []
    }
    test = {
      teams = [data.github_team.infra_team.id]
      users = [data.github_user.scott.id]
    }
    prod = {
      teams = [data.github_team.infra_team.id]
      users = [data.github_user.scott.id]
    }
  }
}


resource "github_repository_environment" "environments" {
  for_each    = local.environments
  environment = "${each.key}-integrations"
  repository  = data.github_repository.repo.name
  reviewers {
    teams = each.value["teams"]
    users = each.value["users"]
  }
}

resource "github_actions_environment_secret" "site_creds" {
  for_each        = local.environments
  repository      = data.github_repository.repo.name
  environment     = github_repository_environment.environments[each.key].environment
  secret_name     = "SITE_CREDENTIALS"
  plaintext_value = data.terraform_remote_state.integrations.outputs.site_credentials
}
