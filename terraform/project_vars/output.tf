output "customer_name" {
  value = "skf-cenit"
}

output "github_users" {
 value = toset([
      "Scott Melhop",
      "Joel Sirefelt",
      "Igor Suchilov",
      "Ivan Surif"
  ])
}

output "user_map" {
  value = {
    "scott.melhop@cognitedata.com" = {
      "github_account" = "scottmelhop"
      "org_member"     = "admin"
    }
    "github@skfcenitbycognite.onmicrosoft.com" = {
      "github_account" = "cognite-skfcenit-cicd"
      "org_member"     = "admin"
    }
  }  
}