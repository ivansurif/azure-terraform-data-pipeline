locals {
  environments = {
    dev = {
      teams = []
      users = []
      protected_branches = false
      resource_group_name = "integration-functions-dev"
    }
    test = {
      teams = [data.github_team.infra_team.id]
      users = [data.github_user.scott.id]
      protected_branches = true
      resource_group_name = "integration-functions-test"

    }
    prod = {
      teams = [data.github_team.infra_team.id]
      users = [data.github_user.scott.id]
      protected_branches = true
      resource_group_name = "integration-functions-prod"
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
  deployment_branch_policy {
    protected_branches     = each.value["protected_branches"]
    custom_branch_policies = false
  }
}

resource "github_actions_environment_secret" "site_creds" {
  for_each        = local.environments
  repository      = data.github_repository.repo.name
  environment     = github_repository_environment.environments[each.key].environment
  secret_name     = "AZURE_RBAC_CREDENTIALS"
  plaintext_value = jsonencode(
    {
      "clientId": data.terraform_remote_state.integrations.outputs.sp_credentials[each.value["resource_group_name"]["CLIENT_ID"]],
      "clientSecret": data.terraform_remote_state.integrations.outputs.sp_credentials[each.value["resource_group_name"]["CLIENT_SECRET"]],
      "subscriptionId": data.terraform_remote_state.integrations.outputs.sp_credentials[each.value["resource_group_name"]["SUBSCIPTION_ID"]],
      "tenantId": data.terraform_remote_state.integrations.outputs.sp_credentials[each.value["resource_group_name"]["TENANT_ID"]],
    }
  )
}
