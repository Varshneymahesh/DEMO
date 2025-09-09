resource "azurerm_subnet" "example" {
    for_each = var.subnets
  name                 = each.key
  resource_group_name  = each.value.rg_name
  virtual_network_name = each.value.vnet_name
  address_prefixes     = each.value.address_prefixes

  
}