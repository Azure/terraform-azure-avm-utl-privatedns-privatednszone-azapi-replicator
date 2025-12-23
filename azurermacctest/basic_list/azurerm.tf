resource "azurerm_private_dns_zone" "test1" {
  name                = "acctestzone1${random_integer.number.result}.com"
  resource_group_name = azurerm_resource_group.test.name
}
