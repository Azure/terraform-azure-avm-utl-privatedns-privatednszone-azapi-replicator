terraform {
  required_version = ">= 1.9, < 2.0"

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

  name              = "acctestzone${random_integer.number.result}.com"
  resource_group_id = azurerm_resource_group.test.id
  enable_telemetry  = var.enable_telemetry
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

  dynamic "identity" {
    for_each = can(module.replicator.azapi_header.identity) ? [module.replicator.azapi_header.identity] : []

    content {
      type         = identity.value.type
      identity_ids = try(identity.value.identity_ids, null)
    }
  }
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

resource "azapi_resource" "post_creation0" {
  count = module.replicator.post_update0 != null ? 1 : 0

  name           = module.replicator.post_update0.azapi_header.name
  parent_id      = azapi_resource.this.id
  type           = module.replicator.post_update0.azapi_header.type
  body           = module.replicator.post_update0.body
  locks          = module.replicator.post_update0.locks
  sensitive_body = module.replicator.post_update0_sensitive_body

  dynamic "timeouts" {
    for_each = module.replicator.timeouts != null ? [module.replicator.timeouts] : []

    content {
      create = timeouts.value.create
      delete = timeouts.value.delete
      read   = timeouts.value.read
      update = timeouts.value.update
    }
  }

  depends_on = [azapi_resource.this]

  lifecycle {
    ignore_changes = [body, sensitive_body]
  }
}
