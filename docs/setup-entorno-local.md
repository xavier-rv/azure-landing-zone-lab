# Preparación del entorno de desarrollo local

Entorno: Windows con WSL2 y Ubuntu 24.04. El repositorio vive en el sistema de ficheros de Linux (`~`), no en `/mnt/c`.
No se usa Docker Desktop: Docker Engine se instala dentro de WSL con systemd.

## Herramientas instaladas

| Herramienta | Versión | Para qué |
|---|---|---|
| Git | 2.43 | Control de versiones |
| Terraform | >= 1.7 | Infraestructura como código |
| Azure CLI | última | Autenticación y operaciones en Azure |
| tflint | 0.65 | Linter de Terraform |
| checkov | 3.3 | Análisis de seguridad del código |
| pre-commit | 4.7 | Hooks antes de cada commit |
| kubectl / kubelogin | 1.37 / 0.2 | Cliente de Kubernetes y login con Entra ID |
| kind | 0.34 | Clúster Kubernetes local para practicar GitOps |
| flux | 2.10 | CLI de Flux (GitOps) |
| Docker Engine | última | Runtime de contenedores para kind |
| GitHub CLI (`gh`) | última | Autenticación y Pull Requests |

## Verificación

Se creó y destruyó un clúster local con `kind create cluster` y `kind delete cluster`: el entorno es válido para practicar GitOps sin cuenta de Azure.

## Flujo de trabajo

- `main` está protegida por un ruleset: no se admiten pushes directos, solo Pull Requests.
- Antes de cada commit se ejecutan los hooks de `pre-commit` (formato, secretos, tflint).
- Seguridad del repositorio: Dependabot, secret scanning y push protection activados.
- Las cuentas de GitHub y Azure del proyecto son personales.
