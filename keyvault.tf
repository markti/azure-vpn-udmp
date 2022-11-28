
locals {
  users = [
    var.admin_user_id
  ]
}

data "azurerm_client_config" "current" {}

resource "azurerm_key_vault" "main" {
  name                        = "kv-${local.suffix}"
  location                    = azurerm_resource_group.main.location
  resource_group_name         = azurerm_resource_group.main.name

  enabled_for_disk_encryption = false
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  purge_protection_enabled    = false

  sku_name = "standard"

}

resource "azurerm_key_vault_access_policy" "terraform_user" {

  key_vault_id = azurerm_key_vault.main.id

  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = data.azurerm_client_config.current.object_id

  certificate_permissions = [
    "Get", "Create", "Delete", "Purge", "Update"
  ]

  key_permissions = [
    "Get", "Create", "Delete", "Purge", "Update"
  ]

  secret_permissions = [
    "Get", "Set", "Delete", "Purge"
  ]
}


resource "azurerm_key_vault_access_policy" "admin_user" {

    count = length(local.users)

  key_vault_id = azurerm_key_vault.main.id

  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = local.users[count.index]

  certificate_permissions = [
    "Get", "List"
  ]

  key_permissions = [
    "Get", "List"
  ]

  secret_permissions = [
    "Get", "List"
  ]
}
