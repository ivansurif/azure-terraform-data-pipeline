terraform {
  backend "azurerm" {
    storage_account_name = "cogniteskfcenittf"
    container_name       = "tfstate"
    key                  = "tier0.iam"

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
