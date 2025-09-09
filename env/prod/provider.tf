terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "4.42.0"
    }
  }
}

provider "azurerm" {
  features {}
  subscription_id = "75146836-fdff-4091-9190-2ee9cca9c8b6"
}