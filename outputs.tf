output "azapi_header" {
  value = local.azapi_header
}

output "body" {
  value = local.body
}

output "locks" {
  value = local.locks
}

# Post-creation operation output for SOA record
output "post_update0" {
  value = local.post_update0
}

output "post_update0_sensitive_body" {
  sensitive = true
  value     = local.post_update0_sensitive_body
}

output "replace_triggers_external_values" {
  value = local.replace_triggers_external_values
}

output "retry" {
  value = local.azapi_header.retry
}

output "sensitive_body" {
  ephemeral = true
  sensitive = true
  value     = local.sensitive_body
}

output "sensitive_body_version" {
  value = local.sensitive_body_version
}

output "timeouts" {
  value = var.timeouts
}
