resource "tls_private_key" "linuxkey" {
    algorithm = "RSA"
    rsa_bits = 4096
}

resource "local_file" "linuxpemkey" {
    filename = "linuxkey.pem"
    content = tls_private_key.linuxkey.private_key_pem  
    depends_on = [ 
        tls_private_key.linuxkey
     ]
}

resource "azurerm_network_interface" "linvm1" {
  name                = "uksamr-tflinvm01"
  location            = local.location
  resource_group_name = local.resource_group_name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.snetc.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_linux_virtual_machine" "linuxvm" {
  name                = "linuxvm"
  resource_group_name = local.resource_group_name
  location            = local.location
  size                = "Standard_B2ms"
  admin_username      = "linuxuser"
  network_interface_ids = [
    azurerm_network_interface.linvm1.id,
  ]

  admin_ssh_key {
    username   = "linuxuser"
    public_key = tls_private_key.linuxkey.public_key_openssh
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-focal"
    sku       = "22_04-lts"
    version   = "latest"
  }
    depends_on = [ 
        azurerm_network_interface.linvm1, 
        azurerm_resource_group.tfrg,
        tls_private_key.linuxkey
        ]

}