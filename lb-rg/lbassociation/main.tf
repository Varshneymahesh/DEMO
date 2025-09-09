
resource "azurerm_network_interface_backend_address_pool_association" "example" {
  network_interface_id    = var.network_interface_id
  ip_configuration_name   = "testconfiguration1"
  backend_address_pool_id = var.backend_address_pool_id
}
