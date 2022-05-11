# provides config details for terraform
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.0.0"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "vnet_main" {
  name     = var.resource_group_name
  location = var.location
  tags = {
    environment = "dev"
    source      = "terraform"
    owner       = "zach"
  }
}

module "vnet-main" {
  source = "Azure/vnet/azurerm"
  resource_group_name = azurerm_resource_group.vnet_main
  vnet_name = var.resource_group_name
  address_space = [var.vnet_cidr_range]
  subnet_prefixes = var.subnet_prefix
  subnet_names = var.subnet_names
  nsg_ids = {}
  tags = {
    environment = "dev"
    costcenter = "IT"
  }
  depends_on = [
    azurerm_resource_group.vnet_main
  ]
}

output "vnet_id" {
  value = module.vnet-main.vnet_id
}