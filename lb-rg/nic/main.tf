resource "azurerm_network_interface" "main" {
  name                = var.nicname
  location            = var.location
  resource_group_name = var.rgname

  ip_configuration {
    name                          = "testconfiguration1"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
  }
}