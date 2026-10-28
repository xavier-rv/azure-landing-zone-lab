# ADR-0002: Región única y entorno efímero

- Estado: aceptada
- Fecha: 2026-10-28

## Contexto
El proyecto se ejecuta con la cuenta gratuita de Azure (200 USD durante 30 días). Los presupuestos de Azure avisan pero no cortan el gasto.

## Decisión
- Región única: Sweden Central (`swc`), por precio y disponibilidad de servicios. Se confirmará con la calculadora de Azure antes de desplegar.
- Recursos que cobran por estar encendidos, detrás de variables booleanas (`enable_firewall`, `enable_bastion`, `enable_lab_vm`), desactivadas por defecto.
- Despliegue y destrucción con un solo comando (`make up` / `make down`), y destrucción al terminar cada sesión.

## Consecuencias
El coste base se mantiene bajo. Cada sesión parte de cero, lo que obliga a que todo sea reproducible como código.
