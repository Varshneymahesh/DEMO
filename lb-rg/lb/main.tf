resource "azurerm_lb" "example" {
  name                = var.lbname
  location            = var.location
  resource_group_name = var.rgname

  frontend_ip_configuration {
    name                 = var.frontend_ip_configuration_name
    public_ip_address_id = var.public_ip_address_id
  }
}
resource "azurerm_lb_backend_address_pool" "pool1" {
  loadbalancer_id = azurerm_lb.example.id
  name            = "BackEndAddressPool"
}

resource "azurerm_lb_probe" "probe" {
  loadbalancer_id = azurerm_lb.example.id
  name            = "ssh-running-probe"
  port            = 80
}
resource "azurerm_lb_rule" "rule" {
  loadbalancer_id                = azurerm_lb.example.id
  name                           = "LBRule"
  protocol                       = "Tcp"
  frontend_port                  = 80
  backend_port                   = 80
  frontend_ip_configuration_name = var.frontend_ip_configuration_name
  backend_address_pool_ids = [azurerm_lb_backend_address_pool.pool1.id]
  probe_id = azurerm_lb_probe.probe.id
}