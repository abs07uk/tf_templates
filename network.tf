locals {
  virtual_network={
    name = "uksamrvnet01"
    address_space = "10.0.0.0/16"
  }

  subnets=[
    {
        name = "uksamrvnet01snet01"
        address_prefix = "10.0.1.0/24"
    },
    {
        name = "uksamrvnet01snet02"
        address_prefix = "10.0.2.0/24"
    },
    {
        name = "uksamrvnet01snet03"
        address_prefix = "10.0.3.0/24"
    },
    {
        name = "uksamrvnet01snet04"
        address_prefix = "10.0.4.0/24"
    }
  ]
}

resource "azurerm_virtual_network" "vnet01" {
    name                = local.virtual_network.name
    location            = local.location
    resource_group_name = local.resource_group_name
    address_space       = [local.virtual_network.address_space]
    depends_on = [
      azurerm_resource_group.tfrg
     ]
}  
resource "azurerm_subnet" "subnets" {
  count = var.number_of_subnets
  name = local.subnets[count.index].name
  resource_group_name = local.resource_group_name
  virtual_network_name = local.virtual_network.name
  address_prefixes = [local.subnets[count.index].address_prefix]
  depends_on = [ 
    azurerm_virtual_network.vnet01
  ]
 }

resource "azurerm_network_security_group" "nsg-1" {
  name                = "ukamrnsg01"
  location            = local.location
  resource_group_name = local.resource_group_name
  security_rule {
    name                       = "allow-rdp"
    priority                   = 1000
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3389"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
depends_on = [ azurerm_resource_group.tfrg ]
}
resource "azurerm_subnet_network_security_group_association" "nsglink" {
  subnet_id                 = data.azurerm_subnet.snetb.id
  network_security_group_id = azurerm_network_security_group.nsg-1.id
}