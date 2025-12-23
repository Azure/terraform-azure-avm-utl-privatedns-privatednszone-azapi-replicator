terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
    azapi = {
      source  = "Azure/azapi"
      version = "~> 2.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.0"
    }
  }
}

provider "azurerm" {
  features {
    resource_group {
      prevent_deletion_if_contains_resources = true
    }
    key_vault {
      purge_soft_delete_on_destroy    = true
      recover_soft_deleted_key_vaults = true
    }
  }
}

provider "azapi" {}

provider "random" {}

resource "random_integer" "number" {
  min = 100000
  max = 999999
}

resource "azurerm_resource_group" "test" {
  name     = "acctestRG-${random_integer.number.result}"
  location = "eastus"
}

resource "azurerm_private_dns_zone" "test2" {
  name                = "acctestzone2${random_integer.number.result}.com"
  resource_group_name = azurerm_resource_group.test.name
}

resource "azurerm_private_dns_zone" "test3" {
  name                = "acctestzone3${random_integer.number.result}.com"
  resource_group_name = azurerm_resource_group.test.name
}
