resource "azurerm_bastion_host" "example" {
  name                = var.bastionname
  location            = var.location
  resource_group_name = var.rgname

  ip_configuration {
    name                 = "configuration"
    subnet_id            = var.subnet_id
    public_ip_address_id = var.public_ip_address_id
  }
}