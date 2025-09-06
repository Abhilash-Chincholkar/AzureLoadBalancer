terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "4.43.0"
    }
  }
}

provider "azurerm" {
features {}
subscription_id = "0f48ce1f-16d2-42ba-8b4f-0bef1a58b563"
}