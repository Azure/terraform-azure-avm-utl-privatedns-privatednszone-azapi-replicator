# Test Cases for azurerm_private_dns_zone

| case name | file url | status | test status |
| ---       | ---      | ---    | ---         |
| basic | https://raw.githubusercontent.com/hashicorp/terraform-provider-azurerm/refs/heads/main/internal/services/privatedns/private_dns_zone_resource_test.go | Completed | test success |
| withTags | https://raw.githubusercontent.com/hashicorp/terraform-provider-azurerm/refs/heads/main/internal/services/privatedns/private_dns_zone_resource_test.go | Completed | test success |
| withTagsUpdate | https://raw.githubusercontent.com/hashicorp/terraform-provider-azurerm/refs/heads/main/internal/services/privatedns/private_dns_zone_resource_test.go | Completed | test success |
| withBasicSOARecord | https://raw.githubusercontent.com/hashicorp/terraform-provider-azurerm/refs/heads/main/internal/services/privatedns/private_dns_zone_resource_test.go | Completed | test success |
| withCompletedSOARecord | https://raw.githubusercontent.com/hashicorp/terraform-provider-azurerm/refs/heads/main/internal/services/privatedns/private_dns_zone_resource_test.go | Completed | test success |
| basicList | https://raw.githubusercontent.com/hashicorp/terraform-provider-azurerm/refs/heads/main/internal/services/privatedns/private_dns_zone_resource_list_test.go | Completed | test success |

---

## Detailed Analysis

### Basic/Foundation Cases (1 case):
1. **`r.basic(data)`** - Creates a basic private DNS zone with minimal configuration (name and resource group)

### Tags-Related Cases (2 cases):
1. **`r.withTags(data)`** - Private DNS zone with multiple tags (environment, cost_center)
2. **`r.withTagsUpdate(data)`** - Tests updating tags on the private DNS zone (reduces from 2 tags to 1)

### SOA Record Cases (2 cases):
1. **`r.withBasicSOARecord(data)`** - Private DNS zone with basic SOA record configuration (email only)
2. **`r.withCompletedSOARecord(data)`** - Private DNS zone with complete SOA record configuration (email, expire_time, minimum_ttl, refresh_time, retry_time, ttl, tags)

### List/Query Cases (1 case):
1. **`r.basicList(data)`** - Creates multiple private DNS zones for list testing (3 zones)

---

## Removed Cases:
- ❌ `r.requiresImport(data)` - Error test case (used with RequiresImportErrorStep to validate import rejection)
- ❌ `r.basicQuery()` - List query configuration (not a resource test case, used for list operations)
- ❌ `r.basicQueryByResourceGroupName(data)` - List query configuration (not a resource test case, used for list operations with filter)

---

## Notes:
- **Test Method: TestAccPrivateDnsZone_resourceIdentity** - Uses `r.basic(data)` but is an identity test (framework/resource identity feature), not a separate configuration case
- The test file `private_dns_zone_resource_identity_gen_test.go` is a generated test for resource identity feature and reuses the `basic` configuration
- The test file `private_dns_zone_resource_list_test.go` contains list/query operations which are primarily for testing list functionality, not traditional resource test cases

---

**Total Valid Test Cases**: 6

---

## Test Usage Summary:

### File: private_dns_zone_resource_test.go
- **TestAccPrivateDnsZone_basic**: Uses `r.basic(data)` ✅
- **TestAccPrivateDnsZone_requiresImport**: Uses `r.basic(data)` and `r.requiresImport(data)` (import error case ❌)
- **TestAccPrivateDnsZone_withTags**: Uses `r.withTags(data)` ✅ and `r.withTagsUpdate(data)` ✅ (tests tag updates)
- **TestAccPrivateDnsZone_withSOARecord**: Uses `r.withBasicSOARecord(data)` ✅ and `r.withCompletedSOARecord(data)` ✅ (tests SOA record lifecycle)

### File: private_dns_zone_resource_list_test.go
- **TestAccNetworkProfile_list_basic**: Uses `r.basicList(data)` ✅ for creating multiple zones, then uses query configs for list operations

### File: private_dns_zone_resource_identity_gen_test.go
- **TestAccPrivateDnsZone_resourceIdentity**: Reuses `r.basic(data)` ✅ (not a separate test case)
