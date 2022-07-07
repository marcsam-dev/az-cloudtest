resource "azurerm_resource_group" "elite_general_resources" {
  name     = "elite_general_resources"
  location = "EastUS2"
}

resource "azurerm_network_interface" "elitedev_nic" {
  name                = "elitedev_nic"
  location            = azurerm_resource_group.elite_general_resources.location
  resource_group_name = azurerm_resource_group.elite_general_resources.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.application_subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.elitedev_pip.id
  }
}

resource "azurerm_public_ip" "elitedev_pip" {
  name                = "elitedev_pip"
  location            = azurerm_resource_group.elite_general_resources.location
  resource_group_name = azurerm_resource_group.elite_general_resources.name
  allocation_method   = "Static"

  tags = {
    environment = "development"
    company     = "marcsamdev"
    managedwith = "terraform"
  }
}

resource "azurerm_linux_virtual_machine" "linux_server" {
  name                = "linux-server"
  location            = azurerm_resource_group.elite_general_resources.location
  resource_group_name = azurerm_resource_group.elite_general_resources.name
  size                = "Standard_F2"
  admin_username      = "adminuser"
  network_interface_ids = [
    azurerm_network_interface.elitedev_nic.id,
  ]

  admin_ssh_key {
    username   = "adminuser"
    public_key = file("~/.ssh/id_rsa.pub")
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }
}