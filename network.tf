resource "azurerm_resource_group" "elite_general_network" {
  name     = var.elite_general_network
  location = var.location
}

resource "azurerm_network_security_group" "elite_devnsg" {
  name                = var.elite_devnsg
  location            = azurerm_resource_group.elite_general_network.location
  resource_group_name = azurerm_resource_group.elite_general_network.name
}

resource "azurerm_virtual_network" "elitedev_vnet" {
  name                = var.elitedev_vnet
  location            = azurerm_resource_group.elite_general_network.location
  resource_group_name = azurerm_resource_group.elite_general_network.name
  address_space       = var.address_space
  dns_servers         = var.dns_servers

  # subnet = []

  tags = {
    environment = "development"
    company     = "marcsamdev"
    managedwith = "terraform"
  }
}
resource "azurerm_route_table" "elite_rtb" {
  name                          = var.elite_rtb
  location                      = azurerm_resource_group.elite_general_network.location
  resource_group_name           = azurerm_resource_group.elite_general_network.name
  disable_bgp_route_propagation = false

  route {
    name           = "elitedev_route1"
    address_prefix = "10.0.0.0/16"
    next_hop_type  = "VnetLocal"
  }

  tags = {
    environment = "development"
    company     = "marcsamdev"
    managedwith = "terraform"
  }
}

resource "azurerm_subnet" "database_subnet" {
  name                 = var.database_subnet
  resource_group_name  = azurerm_resource_group.elite_general_network.name
  virtual_network_name = azurerm_virtual_network.elitedev_vnet.name
  address_prefixes     = var.address_prefixes_database
}

resource "azurerm_subnet" "application_subnet" {
  name                 = var.application_subnet
  resource_group_name  = azurerm_resource_group.elite_general_network.name
  virtual_network_name = azurerm_virtual_network.elitedev_vnet.name
  address_prefixes     = var.address_prefixes_application
}


resource "azurerm_subnet_route_table_association" "elite_rtb_assoc_database" {
  subnet_id      = azurerm_subnet.database_subnet.id
  route_table_id = azurerm_route_table.elite_rtb.id
}

resource "azurerm_subnet_route_table_association" "elite_rtb_assoc_application" {
  subnet_id      = azurerm_subnet.application_subnet.id
  route_table_id = azurerm_route_table.elite_rtb.id
}

resource "azurerm_subnet_network_security_group_association" "elite_devnsg_assoc_database_subnet" {
  subnet_id                 = azurerm_subnet.database_subnet.id
  network_security_group_id = azurerm_network_security_group.elite_devnsg.id
}

resource "azurerm_subnet_network_security_group_association" "elite_devnsg_assoc_application_subnet" {
  subnet_id                 = azurerm_subnet.application_subnet.id
  network_security_group_id = azurerm_network_security_group.elite_devnsg.id
}

resource "azurerm_network_security_rule" "RDP" {
  name                        = "RDP"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "3389"
  source_address_prefix       = var.source_address_prefix 
  destination_address_prefix  = var.destination_address_prefix 
  resource_group_name         = azurerm_resource_group.elite_general_network.name
  network_security_group_name = azurerm_network_security_group.elite_devnsg.name
}



