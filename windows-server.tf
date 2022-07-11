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

  tags = local.common_tags
}



resource "azurerm_windows_virtual_machine" "windows_Server" {
  name                = join("-", ["wind", "server", "dev"])
  location            = azurerm_resource_group.elite_general_resources.location
  resource_group_name = azurerm_resource_group.elite_general_resources.name
  size                = "Standard_DS1"
  admin_username      = join("", [local.admin_username, "adminuser"])
  admin_password      = upper("P@$$w0rd1234!")
  network_interface_ids = [
    azurerm_network_interface.elitedev_nic.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2016-Datacenter"
    version   = "latest"
  }

    tags = local.common_tags
}

