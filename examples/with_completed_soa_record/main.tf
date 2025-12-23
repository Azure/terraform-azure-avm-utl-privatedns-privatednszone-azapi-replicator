terraform {
  required_providers {
    azapi = {
      source  = "Azure/azapi"
      version = "~> 2.0"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
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
  max = 99999
  min = 10000
}

resource "azurerm_resource_group" "test" {
  location = "eastus"
  name     = "acctestRG-${random_integer.number.result}"
}

module "replicator" {
  source = "../.."

  name                = "acctestzone${random_integer.number.result}.com"
  resource_group_id   = azurerm_resource_group.test.id
  resource_group_name = azurerm_resource_group.test.name
  soa_record = {
    email        = "testemail.com"
    expire_time  = 2419200
    minimum_ttl  = 200
    refresh_time = 2600
    retry_time   = 200
    ttl          = 100
    tags = {
      ENv = "Test"
    }
  }
}

resource "azapi_resource" "this" {
  location                         = module.replicator.azapi_header.location
  name                             = module.replicator.azapi_header.name
  parent_id                        = module.replicator.azapi_header.parent_id
  type                             = module.replicator.azapi_header.type
  body                             = module.replicator.body
  ignore_null_property             = module.replicator.azapi_header.ignore_null_property
  locks                            = module.replicator.locks
  replace_triggers_external_values = module.replicator.replace_triggers_external_values
  retry                            = module.replicator.retry
  sensitive_body                   = module.replicator.sensitive_body
  sensitive_body_version           = module.replicator.sensitive_body_version
  tags                             = module.replicator.azapi_header.tags

  dynamic "timeouts" {
    for_each = module.replicator.timeouts != null ? [module.replicator.timeouts] : []

    content {
      create = timeouts.value.create
      delete = timeouts.value.delete
      read   = timeouts.value.read
      update = timeouts.value.update
    }
  }
}

resource "azapi_update_resource" "post_creation0" {
  resource_id = "${azapi_resource.this.id}/SOA/@"
  type        = module.replicator.post_creation0.azapi_header.type
  body        = module.replicator.post_creation0.body
  locks       = module.replicator.post_creation0.locks

  depends_on = [azapi_resource.this]

  lifecycle {
    ignore_changes = [body]
  }
}
