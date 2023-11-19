data "azurerm_subnet" "snetb" {
  name = "uksamrvnet01snet01"
  virtual_network_name = "uksamrvnet01"
  resource_group_name = "tf-rg"
  depends_on = [ azurerm_virtual_network.vnet01 ]
}
# add a subnet as a seperate resource 
resource "azurerm_subnet" "snetc" {
  name =  local.subnets[2].name
  resource_group_name = local.resource_group_name
  virtual_network_name = local.virtual_network.name
  address_prefixes = [local.subnets[2].address_prefix]
  depends_on = [ azurerm_virtual_network.vnet01 ]
}

resource "azurerm_network_interface" "privnic01" {
  name                = "priv-nic01"
  location            = local.location
  resource_group_name = local.resource_group_name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = data.azurerm_subnet.snetb.id
    private_ip_address_allocation = "Dynamic"
  }
  depends_on = [ azurerm_virtual_network.vnet01 ]
}

resource "azurerm_windows_virtual_machine" "tfvm01" {
  name = "uksamr-tfvm01"
  resource_group_name = local.resource_group_name
  location = local.location
  size = "Standard_B2ms"
  admin_username ="adminuser"
  admin_password = "P@ssword1234!"
  network_interface_ids = [azurerm_network_interface.privnic01.id]
  
  os_disk {
    caching = "ReadWrite"
    storage_account_type = "Standard_LRS"
    }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer = "WindowsServer"
    sku = "2019-DataCenter"
    version = "latest"
  }
  depends_on = [ azurerm_virtual_network.vnet01 ]
}
#output the value of the subnet id so that we can view it
/*output "snetb-id" {
  value = data.azurerm_subnet.snetb.id
  
}*/