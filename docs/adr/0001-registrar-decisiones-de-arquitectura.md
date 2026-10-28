# ADR-0001: Registrar las decisiones de arquitectura

- Estado: aceptada
- Fecha: 2026-10-28

## Contexto
El proyecto toma decisiones con compromisos (coste, seguridad, simplicidad). Sin registro, el porqué se pierde.

## Decisión
Cada decisión relevante se documenta en `docs/adr/NNNN-titulo.md` con contexto, decisión y consecuencias. Son breves y no se reescriben: si cambia una decisión, se crea un ADR nuevo que sustituye al anterior.

## Consecuencias
Más trazabilidad y mejor material para explicar el proyecto en entrevistas, a cambio de unos minutos por decisión.
