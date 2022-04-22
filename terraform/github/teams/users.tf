locals {
  github_users = {

    "github@skfcenitbycognite.onmicrosoft.com" = {
      "github_account" = "cognite-skfcenit-cicd"
      "org_member"     = "admin"
    }

    "hakon.treider@cognitedata.com" = {
      "github_account" = "haakonvt"
      "org_member"     = "member"
    }

    "kelvin.sundli@cognitedata.com" = {
      "github_account" = "ks93"
      "org_member"     = "member"
    }

    "joel.sirefelt@cognitedata.com" = {
      "github_account"  = "CogJoel"
      "org_member"      = "member"
      "infra_team_push" = "member"
    }

    "scott.melhop@cognitedata.com" = {
      "github_account" = "scottmelhop"
      "org_member"     = "admin"
    }

    "ivan.surif@cognitedata.com" = {
      "github_account"  = "ivansurif"
      "org_member"      = "admin"

    }

    "igor.suchilov@cognitedata.com" = {
      "github_account"  = "igors-cognite"
      "org_member"      = "member"
      "infra_team_push" = "member"
    }
  }

  external_collaborators = {
    "cognite.test.user@gmail.com" = {
      "github_account"  = "gognite-test-user"
      "org_member"      = "member"
    }
  }
}
