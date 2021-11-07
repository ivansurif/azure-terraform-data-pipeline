terraform {
  backend "azurerm" {
    storage_account_name = "cogniteskfcenittf"
    container_name       = "tfstate"
    key                  = "github_teams"

    # Access Key set as environment variable ARM_ACCESS_KEY

  }
  required_providers {
    github = {
      version = "2.4.1"
    }
  }
  required_version = "~> 1.0.0"
}

provider "github" {
  organization = "cognite-skf-cenit"
}