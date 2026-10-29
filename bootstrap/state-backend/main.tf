data "azurerm_client_config" "current" {}

# Sufijo aleatorio: el nombre de un Storage Account debe ser único en todo Azure.
resource "random_string" "suffix" {
  length  = 6
  lower   = true
  numeric = true
  upper   = false
  special = false
}

resource "azurerm_resource_group" "tfstate" {
  name     = "rg-${var.workload}-tfstate-${var.location_short}"
  location = var.location
  tags     = var.tags
}

resource "azurerm_storage_account" "tfstate" {
  #checkov:skip=CKV_AZURE_35: acceso de red público necesario (equipo local y runners de GitHub); la autorización es solo Entra ID. Ver ADR-0004
  #checkov:skip=CKV_AZURE_59: mismo motivo: el acceso público de red es necesario; el acceso anónimo a blobs sí está desactivado. Ver ADR-0004
  #checkov:skip=CKV2_AZURE_1: sin claves gestionadas por el cliente (CMK): coste y complejidad no justificados en el laboratorio
  #checkov:skip=CKV_AZURE_206: LRS por coste; en producción sería GRS o ZRS. Ver ADR-0004
  #checkov:skip=CKV2_AZURE_33: sin Private Endpoint en el bootstrap para poder ejecutarlo desde fuera de la red
  #checkov:skip=CKV_AZURE_33: no hay colas en esta cuenta, el registro de colas no aplica
  name                = "st${var.workload}tfstate${random_string.suffix.result}"
  resource_group_name = azurerm_resource_group.tfstate.name
  location            = azurerm_resource_group.tfstate.location

  account_kind             = "StorageV2"
  account_tier             = "Standard"
  account_replication_type = "LRS"

  min_tls_version                  = "TLS1_2"
  https_traffic_only_enabled       = true
  allow_nested_items_to_be_public  = false
  cross_tenant_replication_enabled = false

  # Sin claves de acceso: solo se entra con Entra ID.
  shared_access_key_enabled       = false
  default_to_oauth_authentication = true

  blob_properties {
    versioning_enabled = true

    delete_retention_policy {
      days = 7
    }

    container_delete_retention_policy {
      days = 7
    }
  }

  tags = var.tags
}

# Entra ID: quien ejecuta Terraform necesita un rol de DATOS para crear el contenedor.
# Ser Owner de la suscripción no da acceso a los datos de un blob.
resource "azurerm_role_assignment" "state_owner" {
  scope                = azurerm_storage_account.tfstate.id
  role_definition_name = "Storage Blob Data Owner"
  principal_id         = data.azurerm_client_config.current.object_id
}

# Las asignaciones de rol tardan en propagarse por Azure.
resource "time_sleep" "rbac_propagation" {
  create_duration = "60s"

  depends_on = [azurerm_role_assignment.state_owner]
}

resource "azurerm_storage_container" "tfstate" {
  #checkov:skip=CKV2_AZURE_21: sin registro de lecturas por ahora: el workspace de Log Analytics se crea en la Fase 6 y el coste de ingesta no se justifica aqui. Revisar en la Fase 6. Ver ADR-0004
  name                  = "tfstate"
  storage_account_id    = azurerm_storage_account.tfstate.id
  container_access_type = "private"

  depends_on = [time_sleep.rbac_propagation]
}
