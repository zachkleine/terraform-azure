# provides config details for terraform test
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>1.43"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg" {
  name     = "test-rg"
  location = "southcentralus"
  tags = {
    environment = "dev"
    source      = "terraform"
  }
}