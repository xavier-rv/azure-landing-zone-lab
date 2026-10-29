output "resource_group_name" {
  description = "Grupo de recursos que contiene el estado remoto."
  value       = azurerm_resource_group.tfstate.name
}

output "storage_account_name" {
  description = "Nombre del Storage Account del estado remoto."
  value       = azurerm_storage_account.tfstate.name
}

output "storage_account_id" {
  description = "ID del Storage Account (se usa para dar permisos al pipeline)."
  value       = azurerm_storage_account.tfstate.id
}

output "container_name" {
  description = "Contenedor de blobs con los ficheros de estado."
  value       = azurerm_storage_container.tfstate.name
}

output "backend_config" {
  description = "Contenido del fichero backend.hcl para los demás entornos."
  value       = <<-EOT
    resource_group_name  = "${azurerm_resource_group.tfstate.name}"
    storage_account_name = "${azurerm_storage_account.tfstate.name}"
    container_name       = "${azurerm_storage_container.tfstate.name}"
    key                  = "lab.tfstate"
    use_azuread_auth     = true
  EOT
}
