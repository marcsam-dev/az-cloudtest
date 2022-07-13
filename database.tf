resource "azurerm_storage_account" "elite_storageaccount" {
  name                     = join("", ["elite", "storageaccount"])
  location                 = azurerm_resource_group.elite_general_resources.location
  resource_group_name      = azurerm_resource_group.elite_general_resources.name
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_mssql_server" "elitedevsqlserver" {
  name                         = join("", ["elitedev", "sqlserver"])
  location                     = azurerm_resource_group.elite_general_resources.location
  resource_group_name          = azurerm_resource_group.elite_general_resources.name
  version                      = "12.0"
  administrator_login          = join("", ["elitedev", "sqladmin"])
  administrator_login_password = azurerm_key_vault_secret.windows_server_password.value
}

resource "azurerm_mssql_database" "elitedev_database" {
  name           = join("", ["elitedev", "db"])
  server_id      = azurerm_mssql_server.elitedevsqlserver.id
  collation      = "SQL_Latin1_General_CP1_CI_AS"
  license_type   = "LicenseIncluded"
#  max_size_gb    = 3
  read_scale     = false
#  sku_name       = "S0"
  zone_redundant = true

#  extended_auditing_policy {
#    storage_endpoint                        = azurerm_storage_account.elite_storageaccount.primary_blob_endpoint
#    storage_account_access_key              = azurerm_storage_account.elite_storageaccount.primary_access_key
#    storage_account_access_key_is_secondary = true
#    retention_in_days                       = 6
#  }


  tags = local.common_tags
}

resource "azurerm_mssql_firewall_rule" "fwRule" {
  name             = join("", ["fwdevRule", "db"])
  server_id        = azurerm_mssql_server.elitedevsqlserver.id
  start_ip_address = "197.210.54.37"
  end_ip_address   = "197.210.54.37"
}
