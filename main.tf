#Where the provider is from (source) and what version to use (version). Required configuration defined in provider registry
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.0.0"
    }
  }
}

#configures azure provider, not really much to do
provider "azurerm" {
  features {}
}

#creates a resource group, last block is arbitrary name to describe the resource
resource "azurerm_resource_group" "vnet_main" {
  #refernces default = "" of variables.tf for resource group name and location
  name     = var.resource_group_name
  location = var.location
  #tags for fun
  tags = {
    environment = "dev"
    source      = "terraform"
    owner       = "zach"
  }
}

#collection of configs that manages  
module "vnet" {
  #where module comes from 
  source = "Azure/vnet/azurerm"
  version = "2.6.0"
  #assigns resource group based on 
  resource_group_name = azurerm_resource_group.vnet_main.name
  vnet_name = var.resource_group_name
  #address_space expects a list string, can either be done in vars or main
  address_space = var.vnet_cidr_range
  subnet_prefixes = var.subnet_prefix
  subnet_names = var.subnet_names
  nsg_ids = {}
  tags = {
    environment = "dev"
    costcenter = "IT"
  }
  #resource group vnet_main must be created first
  depends_on = [
    azurerm_resource_group.vnet_main
  ]
}

output "vnet_id" {
  value = module.vnet.vnet_id
}