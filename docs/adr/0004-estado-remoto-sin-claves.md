# ADR-0004: Estado remoto sin claves y bootstrap con estado local

- Estado: aceptada
- Fecha: 2026-10-29

## Contexto
Terraform necesita guardar su estado fuera del repositorio. El almacén del estado debe existir antes de poder usarlo, y el estado puede contener datos sensibles.

## Decisión
- Storage Account propio con `shared_access_key_enabled = false`: solo se accede con Entra ID y roles RBAC de datos (`Storage Blob Data Owner` para quien administra, `Storage Blob Data Contributor` para el pipeline).
- Versionado de blobs y borrado lógico de 7 días para poder recuperar un estado dañado.
- Redundancia LRS por coste. En producción se usaría GRS o ZRS.
- Acceso de red público (autorizado solo con Entra ID), porque el equipo local y los runners de GitHub necesitan alcanzarlo. En producción se restringiría por red o Private Endpoint.
- El propio bootstrap usa estado local (huevo y gallina). El estado local no se sube al repositorio.
- Este recurso no se destruye en cada sesión: contiene el estado del resto del entorno.
- Sin registro de diagnóstico del Storage Account hasta la Fase 6 (Log Analytics). Revisar entonces la excepción CKV2_AZURE_21.

## Consecuencias
No existe ninguna clave que pueda filtrarse. A cambio, quien ejecute Terraform necesita un rol de datos, y las asignaciones recientes tardan en propagarse (el código espera 60 segundos).
