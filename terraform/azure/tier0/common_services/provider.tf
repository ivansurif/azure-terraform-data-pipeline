terraform {
  backend "azurerm" {
    storage_account_name = "skfcenittf2"
    container_name       = "tfstate"
    key                  = "azure.tier0.common_services"

    # Access Key set as environment variable ARM_ACCESS_KEY

  }
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "2.82.0"
    }
  }

  required_version = ">= 0.14"
}

provider "azurerm" {
  # Requires the following environment variables
  # ARM_CLIENT_ID
  # ARM_CLIENT_SECRET
  # ARM_SUBSCRIPTION_ID
  # ARM_TENANT_ID
  skip_provider_registration = true

  features {}
}