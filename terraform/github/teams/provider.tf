terraform {
  backend "azurerm" {
    storage_account_name = "cogniteskfcenittf"
    container_name       = "tfstate"
    key                  = "github_teams"

    # Access Key set as environment variable ARM_ACCESS_KEY

  }
  required_providers {
    github = {
      source  = "integrations/github"
      version = "4.17.0"
    }
  }
}

provider "github" {
}