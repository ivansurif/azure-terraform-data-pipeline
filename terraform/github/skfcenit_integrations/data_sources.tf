data "terraform_remote_state" "integrations" {
  backend = "azurerm"

  config = {
    storage_account_name = "cogniteskfcenittf"
    container_name       = "tfstate"
    key                  = "azure.tier1.integrations"

    # Access Key set as environment variable ARM_ACCESS_KEY

  }
}

data "github_repository" "repo" {
  full_name = "cognite-skf-cenit/real-time-integrations"
}