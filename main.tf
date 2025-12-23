locals {
  azapi_header = {
    type                 = "Microsoft.Network/privateDnsZones@2024-06-01"
    name                 = var.name
    location             = "global"
    parent_id            = var.resource_group_id
    tags                 = var.tags
    ignore_null_property = true
    retry                = null
  }
  body = {
    properties = {}
  }
  locks = []
  post_creation0 = var.soa_record != null ? {
    azapi_header = {
      type = "Microsoft.Network/privateDnsZones/SOA@2024-06-01"
    }
    body = {
      properties = {
        ttl = var.soa_record.ttl
        soaRecord = {
          email       = var.soa_record.email
          expireTime  = var.soa_record.expire_time
          minimumTtl  = var.soa_record.minimum_ttl
          refreshTime = var.soa_record.refresh_time
          retryTime   = var.soa_record.retry_time
        }
        metadata = var.soa_record.tags
      }
    }
    locks = local.locks
  } : null
  post_creation0_sensitive_body = var.soa_record != null ? {
    properties = {}
  } : null
  replace_triggers_external_values = {
    name       = { value = var.name }
    soa_record = { value = var.soa_record != null ? true : null }
  }
  sensitive_body = {
    properties = {}
  }
  sensitive_body_version = {}
}
