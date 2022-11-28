
data "azurerm_log_analytics_workspace" "observability" {
  name                = var.log_analytics_workspace_name
  resource_group_name = var.observability_resource_group
}

locals {
  logs = [ "GatewayDiagnosticLog", "TunnelDiagnosticLog" ]
}


module "vgw_monitor" {

  source = "github.com/markti/terraform-azurerm-diagnostic-setting//modules/rando?ref=v1.0.1"

  resource_id                = azurerm_virtual_network_gateway.vpn.id
  log_analytics_workspace_id = data.azurerm_log_analytics_workspace.observability.id
  retention_period           = 30

  logs = [
    "GatewayDiagnosticLog",
    "TunnelDiagnosticLog",
    "RouteDiagnosticLog",
    "IKEDiagnosticLog",
    "P2SDiagnosticLog"
  ]

}


module pip_monitor {

  source = "github.com/markti/terraform-azurerm-diagnostic-setting//modules/rando?ref=v1.0.1"

  resource_id                = azurerm_public_ip.vpn.id
  log_analytics_workspace_id = data.azurerm_log_analytics_workspace.observability.id
  retention_period           = 30

  logs = [
    "DDoSProtectionNotifications",
    "DDoSMitigationFlowLogs",
    "DDoSMitigationReports"
  ]
}
