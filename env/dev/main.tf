module "rg" {
    source = "../../lb-rg/rg"
    location = "central india"
    rg_name = "mylbrg"
}
module "vnet" {
  source = "../../lb-rg/vnet"
  rgname = "mylbrg"
  location = "centralindia"
  vnet_name =   "mylbvnet"
  address_space = ["10.0.0.0/16"]
  depends_on = [ module.rg ]
}
module "subnet" {
    source = "../../lb-rg/subnet"
    
    subnets = {
      app_subnet= {
        rg_name = "mylbrg"
        vnet_name= module.vnet.vnet_name
        location = "centralindia"
        address_prefixes = ["10.0.1.0/24"]
      },
      db_subnet= {
        rg_name = "mylbrg"
        vnet_name= module.vnet.vnet_name
        location = "centralindia"
        address_prefixes = ["10.0.2.0/24"]
    },
    AzureBastionSubnet= {
        rg_name = "mylbrg"
        vnet_name= module.vnet.vnet_name
        location = "centralindia"
        address_prefixes = ["10.0.3.0/24"]

  
}
    }
    depends_on = [ module.rg , module.vnet ]
}


module "nic" {
    source = "../../lb-rg/nic"
    rgname = "mylbrg"
    location = "centralindia"
    nicname = "mylbnic"
    subnet_id = module.subnet.subnet_ids["app_subnet"]
    depends_on = [ module.rg , module.subnet ]
  
}
module "myvm" {
    source = "../../lb-rg/vm"
    rgname = "mylbrg"
    vmname = "myvm01"
    location = "centralindia"
    network_interface_id = module.nic.network_interface_ids
    depends_on = [ module.rg , module.nic ]
  
}
module "nic2" {
    source = "../../lb-rg/nic"
    rgname = "mylbrg"
    location = "centralindia"
    nicname = "mylbnic2"
    subnet_id = module.subnet.subnet_ids["db_subnet"]
    depends_on = [ module.rg , module.subnet ]
  
}
module "myvm2" {
    source = "../../lb-rg/vm"
    rgname = "mylbrg"
    vmname = "myvm02"
    location = "centralindia"
    network_interface_id = module.nic2.network_interface_ids
    depends_on = [ module.rg, module.nic2 ]
  
}

module "nsg" {
  source = "../../lb-rg/nsg"
  rgname = "mylbrg"
  location = "centralindia"
  securitygroupname = "mynsg01"
  security_rules = {
    rule1 ={
        rulename = "RDP"
        priority= "102"
        destination_port_range = "3389"

    },
       rule2 ={
        rulename = "ss"
        priority= "150"
        destination_port_range = "22"

    },
       rule3 ={
        rulename = "HTTP"
        priority= "200"
        destination_port_range = "80"

    }
  }
  depends_on = [ module.rg ]
}
module "nsasociation" {
    source = "../../lb-rg/asssnsg"
    network_security_group_id = module.nsg.network_security_group_id
    subnet_id = module.subnet.subnet_ids["app_subnet"]
    depends_on = [ module.subnet, module.nsg ]
}
module "nsasociation1" {
    source = "../../lb-rg/asssnsg"
    network_security_group_id = module.nsg.network_security_group_id
    subnet_id = module.subnet.subnet_ids["db_subnet"]
    depends_on = [ module.subnet, module.nsg ]
}
module "myip" {
    source = "../../lb-rg/ip"
    ipname = "newip"
    rgname = "mylbrg"
    location = "centralindia"
    depends_on = [ module.rg ]
  
}
module "Bastionip" {
    source = "../../lb-rg/ip"
    ipname = "bastionip"
    rgname = "mylbrg"
    location = "centralindia"
    depends_on = [ module.rg ]
  
}

module "mybastion" {
    source = "../../lb-rg/bastion"
    location = "centralindia"
    rgname = "mylbrg"
    bastionname = "newbastion01"
    subnet_id =module.subnet.subnet_ids["AzureBastionSubnet"]
    public_ip_address_id = module.Bastionip.public_ip_address_id
    depends_on = [ module.rg, module.subnet, module.myip ]
  
}

module "mylb" {
    source = "../../lb-rg/lb"
    rgname = "mylbrg"
    location = "centralindia"
    lbname = "mylb01"
    public_ip_address_id = module.myip.public_ip_address_id
    frontend_ip_configuration_name = "newip"
    depends_on = [ module.rg, module.myip ]

}
module "lb-ass" {
    source = "../../lb-rg/lbassociation"
  network_interface_id = module.nic.network_interface_ids
  backend_address_pool_id = module.mylb.backend_address_pool_id
  depends_on = [ module.nic, module.mylb ]
}
module "lb-ass1" {
    source = "../../lb-rg/lbassociation"
  network_interface_id = module.nic2.network_interface_ids
  backend_address_pool_id = module.mylb.backend_address_pool_id
  depends_on = [ module.mylb,module.nic2 ]
}