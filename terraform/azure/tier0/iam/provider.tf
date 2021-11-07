terraform {
  backend "azurerm" {
    storage_account_name = module.project_vars.storage_account_name
    container_name       = "tfstate"
    key                  = local.state_key

    # Access Key set as environment variable ARM_ACCESS_KEY
    
  }
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "2.82.0"
    }
  }
}

provider "azurerm" {
  # Requires the following environment variables
  # ARM_CLIENT_ID
  # ARM_CLIENT_SECRET
  # ARM_SUBSCRIPTION_ID
  # ARM_TENANT_ID
  features {}
}
