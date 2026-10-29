mock_provider "azurerm" {
  mock_data "azurerm_client_config" {
    defaults = {
      tenant_id       = "00000000-0000-0000-0000-000000000000"
      subscription_id = "00000000-0000-0000-0000-000000000000"
      object_id       = "00000000-0000-0000-0000-000000000001"
      client_id       = "00000000-0000-0000-0000-000000000002"
    }
  }

  # El provider valida que "scope" tenga forma de ID de Azure: el mock debe darle uno válido.
  mock_resource "azurerm_storage_account" {
    defaults = {
      id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-alz-tfstate-swc/providers/Microsoft.Storage/storageAccounts/stalztfstateabc123"
    }
  }
}

mock_provider "random" {}
mock_provider "time" {}

override_resource {
  target = random_string.suffix
  values = {
    result = "abc123"
  }
}

run "nombres_y_ubicacion" {
  command = apply

  assert {
    condition     = azurerm_storage_account.tfstate.name == "stalztfstateabc123"
    error_message = "El nombre del Storage Account no sigue la convención."
  }

  assert {
    condition     = azurerm_resource_group.tfstate.name == "rg-alz-tfstate-swc"
    error_message = "El nombre del grupo de recursos no sigue la convención."
  }

  assert {
    condition     = azurerm_resource_group.tfstate.location == "swedencentral"
    error_message = "La región debe ser Sweden Central."
  }
}

run "seguridad_del_almacen" {
  command = apply

  assert {
    condition     = azurerm_storage_account.tfstate.shared_access_key_enabled == false
    error_message = "Las claves de acceso compartidas deben estar desactivadas."
  }

  assert {
    condition     = azurerm_storage_account.tfstate.allow_nested_items_to_be_public == false
    error_message = "No se permite acceso anónimo a los blobs."
  }

  assert {
    condition     = azurerm_storage_account.tfstate.min_tls_version == "TLS1_2"
    error_message = "TLS mínimo debe ser 1.2."
  }

  assert {
    condition     = azurerm_storage_account.tfstate.blob_properties[0].versioning_enabled == true
    error_message = "El versionado de blobs debe estar activado."
  }

  assert {
    condition     = azurerm_storage_container.tfstate.container_access_type == "private"
    error_message = "El contenedor debe ser privado."
  }
}

run "etiquetas_obligatorias" {
  command = apply

  assert {
    condition = alltrue([
      for k in ["owner", "environment", "cost-center"] :
      contains(keys(azurerm_storage_account.tfstate.tags), k)
    ])
    error_message = "Faltan etiquetas obligatorias."
  }
}
