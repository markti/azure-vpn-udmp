resource "random_string" "random_suffix" {
  length           = 6
  lower            = true
  special          = false
}

resource "azurerm_resource_group" "main" {
  name     = "rg-vpn-${random_string.random_suffix.result}"
  location = "East US 2"
}