resource "azurerm_public_ip" "example" {
  name                = var.ipname
  location            = var.location
  resource_group_name = var.rgname
  allocation_method   = "Static"
  sku                 = "Standard"
}