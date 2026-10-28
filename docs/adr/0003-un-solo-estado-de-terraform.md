# ADR-0003: Un solo estado de Terraform para el entorno lab

- Estado: aceptada
- Fecha: 2026-10-28

## Contexto
En entornos empresariales el estado se separa por capas (red, gobierno, cargas) para limitar el impacto de un error y permitir ciclos de cambio distintos.

## Decisión
Un único estado remoto para `environments/lab`, más otro independiente para `bootstrap/`. Prima el despliegue y la destrucción con un solo comando.

## Consecuencias
Se simplifica la operación. Se asume que en producción habría que dividir el estado por capas.
