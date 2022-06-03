resource "azurerm_public_ip" "vpn" {
  
  name                = "pip-vgw-vpn-${local.suffix}"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  allocation_method   = "Dynamic"

}

resource "azurerm_virtual_network_gateway" "vpn" {

  name                = "vgw-vpn-${local.suffix}"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  type     = "Vpn"
  vpn_type = "RouteBased"

  active_active = false
  enable_bgp    = false
  sku           = "VpnGw2"

  ip_configuration {
    name                          = "vnetGatewayConfig"
    public_ip_address_id          = azurerm_public_ip.vpn.id
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = azurerm_subnet.gateway.id
  }

}

resource "azurerm_virtual_network_gateway_connection" "onpremise" {

  name                = "vgw-vpn-${local.suffix}-connection"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  type                           = "IPsec"
  connection_protocol            = "IKEv2"
  enable_bgp                     = false
  local_azure_ip_address_enabled = false
  virtual_network_gateway_id     = azurerm_virtual_network_gateway.vpn.id
  local_network_gateway_id       = azurerm_local_network_gateway.onpremise.id
  dpd_timeout_seconds            = 45

  shared_key = var.preshared_key

  ipsec_policy {

    dh_group         = "DHGroup2"
    ike_encryption   = "AES256"
    ike_integrity    = "SHA1"
    ipsec_encryption = "AES256"
    ipsec_integrity  = "SHA1"
    pfs_group        = "PFS2"

  }

}

resource "azurerm_local_network_gateway" "onpremise" {

  name                = "lgw-vpn-${local.suffix}"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  gateway_address     = var.local_ip_address
  address_space       = [var.local_address_space]

}