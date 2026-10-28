# Convención de nombres y etiquetas

## Patrón de nombres

`<tipo>-<carga>-<componente>-<región>`, todo en minúsculas.

- Carga: `alz`
- Región: `swc` (Sweden Central)
- Ejemplos: `rg-alz-hub-swc`, `vnet-alz-spoke-aks-swc`, `snet-aks-nodes`, `nsg-alz-aks-swc`, `rt-alz-aks-swc`, `aks-alz-lab-swc`, `log-alz-lab-swc`, `pep-alz-kv-swc`

## Recursos con restricciones especiales

- Storage Account: sin guiones, 3-24 caracteres, único globalmente. Patrón `stalz<propósito><sufijo aleatorio>`.
- Key Vault: 3-24 caracteres, único globalmente. Patrón `kv-alz-<sufijo aleatorio>`.

## Etiquetas obligatorias

| Etiqueta | Valor en este proyecto |
|---|---|
| `owner` | `xavier-rv` |
| `environment` | `lab` |
| `cost-center` | `cc-portfolio-lab` |

Se definen una sola vez en `environments/lab/lab.tfvars` y se aplican a todos los recursos.
Azure Policy denegará la creación de recursos sin estas etiquetas (fase 5).
