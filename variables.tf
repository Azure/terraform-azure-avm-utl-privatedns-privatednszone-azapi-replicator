variable "name" {
  type        = string
  description = "(Required) The name of the Private DNS Zone. Must be a valid domain name. Changing this forces a new resource to be created."
  nullable    = false
}

variable "resource_group_id" {
  type        = string
  description = "(Required) The ID of the Resource Group where the Private DNS Zone should exist."
  nullable    = false
}

variable "resource_group_name" {
  type        = string
  description = "(Required) Specifies the resource group where the resource exists. Changing this forces a new resource to be created."
  nullable    = false
}

variable "enable_telemetry" {
  type        = bool
  default     = true
  description = <<DESCRIPTION
This variable controls whether or not telemetry is enabled for the module.
For more information see <https://aka.ms/avm/telemetryinfo>.
If it is set to false, then no telemetry will be collected.
DESCRIPTION
  nullable    = false
}

variable "soa_record" {
  type = object({
    email        = string
    expire_time  = optional(number, 2419200)
    minimum_ttl  = optional(number, 10)
    refresh_time = optional(number, 3600)
    retry_time   = optional(number, 300)
    tags         = optional(map(string))
    ttl          = optional(number, 3600)
  })
  default     = null
  description = <<-EOT
 - `email` - (Required) The email contact for the SOA record.
 - `expire_time` - (Optional) The expire time for the SOA record. Defaults to `2419200`.
 - `minimum_ttl` - (Optional) The minimum Time To Live for the SOA record. By convention, it is used to determine the negative caching duration. Defaults to `10`.
 - `refresh_time` - (Optional) The refresh time for the SOA record. Defaults to `3600`.
 - `retry_time` - (Optional) The retry time for the SOA record. Defaults to `300`.
 - `tags` - (Optional) A mapping of tags to assign to the Record Set.
 - `ttl` - (Optional) The Time To Live of the SOA Record in seconds. Defaults to `3600`.
EOT

  validation {
    condition = var.soa_record == null || (
      length(var.soa_record.email) > 0 &&
      length(split(".", var.soa_record.email)) >= 2 &&
      length(split(".", var.soa_record.email)) <= 34 &&
      alltrue([for segment in split(".", var.soa_record.email) : segment != ""]) &&
      alltrue([for segment in split(".", var.soa_record.email) : length(segment) <= 63]) &&
      can(regex("^[a-zA-Z0-9._-]+$", var.soa_record.email))
    )
    error_message = "The `email` must be a valid format: non-empty, between 2 and 34 dot-separated segments, each segment 1-63 characters, no consecutive periods, and only containing letters, numbers, underscores, dashes, and periods."
  }
  validation {
    condition = var.soa_record == null || (
      length(format("%s%s", var.name, trimsuffix(var.soa_record.email, "."))) <= 253
    )
    error_message = "The value for `email` which is concatenated with Private DNS Zone `name` cannot exceed 253 characters excluding a trailing period."
  }
  validation {
    condition = var.soa_record == null || (
      var.soa_record.expire_time >= 0
    )
    error_message = "The `expire_time` must be at least 0."
  }
  validation {
    condition = var.soa_record == null || (
      var.soa_record.minimum_ttl >= 0
    )
    error_message = "The `minimum_ttl` must be at least 0."
  }
  validation {
    condition = var.soa_record == null || (
      var.soa_record.refresh_time >= 0
    )
    error_message = "The `refresh_time` must be at least 0."
  }
  validation {
    condition = var.soa_record == null || (
      var.soa_record.retry_time >= 0
    )
    error_message = "The `retry_time` must be at least 0."
  }
  validation {
    condition = var.soa_record == null || (
      var.soa_record.ttl >= 0 && var.soa_record.ttl <= 2147483647
    )
    error_message = "The `ttl` must be between 0 and 2147483647."
  }
}

variable "tags" {
  type        = map(string)
  default     = null
  description = "(Optional) A mapping of tags to assign to the resource."
}

variable "timeouts" {
  type = object({
    create = optional(string, "30m")
    delete = optional(string, "30m")
    read   = optional(string, "5m")
    update = optional(string, "30m")
  })
  default = {
    create = "30m"
    delete = "30m"
    read   = "5m"
    update = "30m"
  }
  description = <<-EOT
 - `create` - (Optional) Specifies the timeout for create operations. Defaults to 30 minutes.
 - `delete` - (Optional) Specifies the timeout for delete operations. Defaults to 30 minutes.
 - `read` - (Optional) Specifies the timeout for read operations. Defaults to 5 minutes.
 - `update` - (Optional) Specifies the timeout for update operations. Defaults to 30 minutes.
EOT
  nullable    = false
}
