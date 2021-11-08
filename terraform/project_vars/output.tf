output "customer_name" {
  value = "skf-cenit"
}


output "github_users" {
  value = {

    "github@skfcenitbycognite.onmicrosoft.com" = {
      "github_account" = "cognite-skfcenit-cicd"
      "org_member"     = "admin"
    }

    "joel.sirefelt@cognitedata.com" = {
      "github_account" = "CogJoel"
      "org_member"     = "member"
    }

    "scott.melhop@cognitedata.com" = {
      "github_account" = "scottmelhop"
      "org_member"     = "admin"
    }
  }
}