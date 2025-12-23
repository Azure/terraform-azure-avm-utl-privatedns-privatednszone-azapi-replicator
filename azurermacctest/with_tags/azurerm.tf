resource "azurerm_private_dns_zone" "test" {
  name                = "acctestzone${random_integer.number.result}.com"
  resource_group_name = azurerm_resource_group.test.name

  tags = {
    environment = "Production"
    cost_center = "MSFT"
  }
}
