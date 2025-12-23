# Migration Plan for azurerm_private_dns_zone.this

## Resource Information
- **Resource Type**: `azurerm_private_dns_zone`
- **Resource Name**: `this`
- **Provider**: hashicorp/azurerm
- **Source Code**: `internal/services/privatedns/private_dns_zone_resource.go`

## Azure Resource Type Determination

### Evidence from Provider Source Code

From the `resourcePrivateDnsZoneCreateUpdate` function in `private_dns_zone_resource.go` (lines 161-229):

```go
func resourcePrivateDnsZoneCreateUpdate(d *pluginsdk.ResourceData, meta interface{}) error {
	client := meta.(*clients.Client).PrivateDns.PrivateZonesClient
	// ...
	id := privatezones.NewPrivateDnsZoneID(subscriptionId, d.Get("resource_group_name").(string), d.Get("name").(string))
	// ...
	parameters := privatezones.PrivateZone{
		Location: pointer.To("global"),
		Tags:     tags.Expand(d.Get("tags").(map[string]interface{})),
	}
	
	options := privatezones.CreateOrUpdateOperationOptions{
		IfMatch:     pointer.To(""),
		IfNoneMatch: pointer.To(""),
	}
	
	if err := client.CreateOrUpdateThenPoll(ctx, id, parameters, options); err != nil {
		return fmt.Errorf("creating/updating %s: %s", id, err)
	}
```

The function uses `client.PrivateZonesClient.CreateOrUpdateThenPoll()` which maps to the Azure REST API for Private DNS Zones.

### Azure SDK Import Evidence

From line 16-17:
```go
"github.com/hashicorp/go-azure-sdk/resource-manager/privatedns/2024-06-01/privatedns"
"github.com/hashicorp/go-azure-sdk/resource-manager/privatedns/2024-06-01/privatezones"
```

This confirms the resource uses:
- **API Version**: `2024-06-01`
- **Resource Provider**: `Microsoft.Network`
- **Resource Type**: `privateDnsZones`

### Azure Resource Type
**`Microsoft.Network/privateDnsZones@2024-06-01`**

---

## Schema Deconstruction

Based on the schema definition in `resourcePrivateDnsZone()` (lines 32-158):

## Planning Task List

| No. | Path | Type | Required | Status | Proof Doc Markdown Link |
|-----|------|------|----------|--------|-----------|
| 1 | name | Argument | Yes | ✅ Completed | [1.name.md](1.name.md) |
| 2 | resource_group_name | Argument | Yes | ✅ Completed | [2.resource_group_name.md](2.resource_group_name.md) |
| 3 | tags | Argument | No | ✅ Completed | [3.tags.md](3.tags.md) |
| 4 | __check_root_hidden_fields__ | HiddenFieldsCheck | Yes | ✅ Completed | [4.__check_root_hidden_fields__.md](4.__check_root_hidden_fields__.md) |
| 5 | soa_record | Block | No | ✅ Completed | [5.soa_record.md](5.soa_record.md) |
| 6 | soa_record.email | Argument | Yes | ✅ Completed | [6.soa_record.email.md](6.soa_record.email.md) |
| 7 | soa_record.expire_time | Argument | No | ✅ Completed | [7.soa_record.expire_time.md](7.soa_record.expire_time.md) |
| 8 | soa_record.minimum_ttl | Argument | No | ✅ Completed | [8.soa_record.minimum_ttl.md](8.soa_record.minimum_ttl.md) |
| 9 | soa_record.refresh_time | Argument | No | ✅ Completed | [9.soa_record.refresh_time.md](9.soa_record.refresh_time.md) |
| 10 | soa_record.retry_time | Argument | No | ✅ Completed | [10.soa_record.retry_time.md](10.soa_record.retry_time.md) |
| 11 | soa_record.ttl | Argument | No | ✅ Completed | [11.soa_record.ttl.md](11.soa_record.ttl.md) |
| 12 | soa_record.tags | Argument | No | ✅ Completed | [12.soa_record.tags.md](12.soa_record.tags.md) |
| 13 | timeouts | Block | No | ✅ Completed | [13.timeouts.md](13.timeouts.md) |
| 14 | timeouts.create | Argument | No | ✅ Completed | [14.timeouts.create.md](14.timeouts.create.md) |
| 15 | timeouts.delete | Argument | No | ✅ Completed | [15.timeouts.delete.md](15.timeouts.delete.md) |
| 16 | timeouts.read | Argument | No | ✅ Completed | [16.timeouts.read.md](16.timeouts.read.md) |
| 17 | timeouts.update | Argument | No | ✅ Completed | [17.timeouts.update.md](17.timeouts.update.md) |

---

## Notes

### Schema Analysis Details

1. **Root Level Required Arguments:**
   - `name` (string, ForceNew) - The Private DNS Zone name
   - `resource_group_name` (string) - Resource group name with case-insensitive diff suppression

2. **Root Level Optional Arguments:**
   - `tags` (map) - Tags for the zone

3. **Nested Block - soa_record (Optional, MaxItems: 1, ForceNew):**
   - `email` (string, Required) - SOA email with custom validation
   - `expire_time` (int, Optional, Default: 2419200)
   - `minimum_ttl` (int, Optional, Default: 10)
   - `refresh_time` (int, Optional, Default: 3600)
   - `retry_time` (int, Optional, Default: 300)
   - `ttl` (int, Optional, Default: 3600)
   - `tags` (map, Optional) - Tags for the SOA record

4. **Computed Fields (not in migration):**
   - `number_of_record_sets`
   - `max_number_of_record_sets`
   - `max_number_of_virtual_network_links`
   - `max_number_of_virtual_network_links_with_registration`
   - `soa_record.fqdn`
   - `soa_record.host_name`
   - `soa_record.serial_number`

### Special Considerations

1. **Location is always "global"** for Private DNS Zones (hardcoded in the provider)
2. **SOA Record** is created/updated via a separate API call after the zone is created
3. The `timeouts` block in the current resource is meta-configuration and doesn't need migration to azapi body
4. The provider uses API version `2024-06-01`

---

## Migration Target

The migration will convert:
```hcl
resource "azurerm_private_dns_zone" "this" {
  name                = var.name
  resource_group_name = var.resource_group_name
  tags                = var.tags
  
  dynamic "soa_record" {
    for_each = var.soa_record == null ? [] : [var.soa_record]
    content {
      email        = soa_record.value.email
      expire_time  = soa_record.value.expire_time
      minimum_ttl  = soa_record.value.minimum_ttl
      refresh_time = soa_record.value.refresh_time
      retry_time   = soa_record.value.retry_time
      tags         = soa_record.value.tags
      ttl          = soa_record.value.ttl
    }
  }
}
```

To:
```hcl
resource "azapi_resource" "this" {
  type      = "Microsoft.Network/privateDnsZones@2024-06-01"
  name      = var.name
  parent_id = azapi_resource_group.example.id  # or use data source
  location  = "global"
  
  body = {
    properties = {
      # Properties go here based on task completion
    }
    tags = var.tags
  }
}

# Note: SOA record may need separate azapi_update_resource or be handled in properties
```
