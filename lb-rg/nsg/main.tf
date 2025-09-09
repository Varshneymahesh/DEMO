resource "azurerm_network_security_group" "example" {
  name                = var.securitygroupname
  location            = var.location
  resource_group_name = var.rgname

  dynamic security_rule {
    for_each = var.security_rules
    content {
          name                       = security_rule.value.rulename
    priority                   = security_rule.value.priority
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = security_rule.value.destination_port_range
    source_address_prefix      = "*"
    destination_address_prefix = "*"
      
    }
    
  }

  
}

