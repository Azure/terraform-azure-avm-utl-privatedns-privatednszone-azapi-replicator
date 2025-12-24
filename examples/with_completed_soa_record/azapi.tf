module "replicator" {
  source = "../.."

  name              = "acctestzone${random_integer.number.result}.com"
  resource_group_id = azurerm_resource_group.test.id
  enable_telemetry  = var.enable_telemetry
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

moved {
  from = azurerm_private_dns_zone.original
  to   = azapi_resource.this
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
  type        = module.replicator.post_update0.azapi_header.type
  body        = module.replicator.post_update0.body
  locks       = module.replicator.post_update0.locks

  depends_on = [azapi_resource.this]

  lifecycle {
    ignore_changes = [body]
  }
}
