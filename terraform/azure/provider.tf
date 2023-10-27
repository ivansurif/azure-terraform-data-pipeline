terraform {
  backend "azurerm" {
    storage_account_name = "terra4mstate"
    container_name       = "tfstate"
    key                  = "azure.tier0.slack_toolbox"
    # Access Key set as environment variable ARM_ACCESS_KEY

  }
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.77.0"
    }
  }

  required_version = ">= 1.6"
}

provider "azurerm" {
  # Requires the following environment variables
  # ARM_CLIENT_SECRET

  client_id       = "d2e51d5d-9851-4045-bb80-f75cda8c4a14"
  # client_secret   = "" Uses default variable name ARM_CLIENT_SECRET
  subscription_id = "2152bb9e-3b7e-4eef-a07d-36e8897d34aa"
  tenant_id       = "b8c39159-a389-4b78-993a-0c4d467c6229"
  
  features {}
  skip_provider_registration = false
}