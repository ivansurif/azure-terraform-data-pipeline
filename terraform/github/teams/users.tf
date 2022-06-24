locals {
  github_users = {

    "github@skfcenitbycognite.onmicrosoft.com" = {
      "github_account" = "cognite-skfcenit-cicd"
      "org_member"     = "admin"
    }

    "ivan.surif@cognitedata.com" = {
      "github_account"  = "ivansurif"
      "org_member"      = "admin"
    }

    "david.mendez@skf.com" = {
      "github_account"  = "davidmendezr"
      "org_member"      = "member"
    }

  }

  external_collaborators = {
    "cognite.test.user@gmail.com" = {
      "github_account"  = "gognite-test-user"
      "org_member"      = "member"
    }
  }

}
