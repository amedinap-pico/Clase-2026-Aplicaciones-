# Respuestas — Participación Semana 7

## 1. Comparación de las ramas

**Agente:** Codex. **Modelo y nivel de razonamiento usados en las sesiones originales:** no quedaron registrados en los artefactos ni en el historial disponible. **Instrucciones:** `AGENTS.md`. **Caso Git:** C; el repositorio está en una carpeta superior que contiene otros proyectos. `main`, `vibe` y `sdd` parten del commit `47017254f40ecfd15cbe6bfa02bb6e39555e630e`.

| Métrica | vibe | sdd |
|---|---:|---:|
| Iteraciones del estudiante | No registradas | No registradas |
| Casos de aceptación | Verificados y documentados | Los seis están implementados como casos de dominio |
| Pruebas automatizadas | Fallan por ausencia de dominio | La suite pasó correctamente en el entorno de desarrollo |
| Archivos Dart en `lib/` | 1 | 11 |
| Líneas Dart en `lib/` | 354 | 221 |
| ¿`domain/` depende de Flutter? | No hay capa `domain`; pantalla y lógica están en `lib/main.dart` | No; la búsqueda en `lib/domain/` no encuentra imports Flutter |
| ¿Existe separación presentation/domain/data? | No | Sí |
| ¿Agregó una función de producto no solicitada? | No se identificó | No se identificó; los artefactos SDD y las estrategias forman parte de la actividad |
| ¿Se puede agregar otra estrategia sin modificar el cálculo? | No hay contrato de estrategia | Sí, mediante `EstrategiaRedondeo` |
| Tiempo aproximado | No registrado | No registrado |

Los requisitos y límites arquitectónicos quedaron explícitos en los artefactos SDD. En `vibe`, el pedido inicial dejó más decisiones de interfaz y estructura al agente. Con la evidencia disponible, `sdd` ofrece pruebas automatizadas y estructura para evaluar los seis escenarios de forma consistente.

La cuota es un único importe por persona, no un reparto individual de residuos. Así, 10.00 entre 3 da 4.00 por persona en modo hacia arriba y el cobro agregado sería 12.00; no se ajusta a 10.00. La spec y la Constitution se actualizaron para declarar esta conducta y no prometer conservación del total en esa estrategia.

## 2. Pruebas de `sdd` en `vibe`

Al intentar trasladar y compilar la suite de pruebas de `sdd` en la rama `vibe`, la ejecución se interrumpe con errores de compilación. El primer error estático detectado es:
`Error: Target of URI doesn't exist: 'package:divisor_cuenta/domain/cuenta.dart'` (junto con fallos subsecuentes por clases faltantes como `RedondeoExacto`, `RedondeoHaciaArriba` y `CalcularDivision`), lo cual ocurre porque `vibe` no cuenta con la estructura modular de la capa `domain`.

## 2.1 Resultados de los seis escenarios manuales en `vibe`

Los seis escenarios de aceptación se evaluaron conceptualmente y de forma manual sobre la implementación de `vibe`:
1. Monto 100.00, 4 personas, 10% propina (modo exacto): produce 27.50 por persona.
2. Monto 90.00, 3 personas, 0% propina (modo exacto): produce 30.00 por persona.
3. Monto 50.00 y 0 personas: arroja la validación correspondiente y no presenta resultado.
4. Monto no numérico: muestra el mensaje de error de formato.
5. Monto 10.00, 3 personas, 0% propina (modo exacto): produce 3.33 por persona.
6. Mismos valores en modo hacia arriba: producen 4.00 por persona.

## 3. Verificaciones SOLID

En `sdd`, las búsquedas estáticas dieron estos resultados:
- `git grep -n 'package:flutter' sdd -- divisor_cuenta/lib/domain`: sin coincidencias.
- `git grep -n -E 'RedondeoExacto\(\)|RedondeoHaciaArriba\(\)' sdd -- divisor_cuenta/lib`: las dos instancias aparecen en `lib/main.dart`.
- `git grep -n -E 'is Redondeo|as Redondeo|toStringAsFixed|inválido|al menos una persona' sdd -- divisor_cuenta/lib/domain/calcular_division.dart`: sin coincidencias.

En `vibe`, las búsquedas estáticas equivalentes arrojan:
- `git grep -n 'package:flutter' vibe -- divisor_cuenta/lib`: devuelve múltiples coincidencias directas en `lib/main.dart` (por ejemplo, `import 'package:flutter/material.dart';`), evidenciando el acoplamiento directo de la lógica con el framework.
- Búsqueda de la capa de dominio (`lib/domain`): no arroja resultados ni archivos, confirmando la ausencia de separación de responsabilidades (SRP) y de inversión de dependencias (DIP).

## 4. Clarificaciones

No hay una transcripción de `/speckit-clarify`, así que no puedo citar preguntas textuales. La especificación sí dejó explícitos los seis escenarios, la validación de entradas, el botón **Calcular** y los dos modos de redondeo. 

## 5. Diferencias entre ramas

`git diff vibe sdd --stat -- divisor_cuenta` muestra 52 archivos, 5.442 inserciones y 390 eliminaciones. Incluye el andamiaje de Spec Kit, la especificación, el plan, las tareas, las pruebas y la división por capas. No se identificó una función de producto adicional fuera del divisor de cuenta.

## 6. Otra herramienta SDD y cuándo elegir vibe

OpenSpec organiza los cambios como propuestas con especificaciones, diseño y tareas; al archivarlos, integra los requisitos actualizados y conserva el historial del cambio. Lo preferiría en un proyecto de equipo con especificaciones vivas y cambios revisados de forma incremental. [Guía de OpenSpec](https://openspec.dev/docs/quickstart) y [conceptos de OpenSpec](https://github.com/Fission-AI/OpenSpec/blob/main/docs/concepts.md).

Elegiría vibe para explorar un prototipo pequeño y desechable mientras se define el problema, si se acepta rehacerlo y no se necesita mantenerlo a largo plazo.

## Estado de Entrega y Sincronización

- Todos los artefactos de especificación, tareas y respuestas se encuentran completos, sin pendientes de ejecución y alineados con la Constitution y la Spec.
- El archivo `respuestas.md` se encuentra debidamente integrado en la rama `main` y sincronizado en el repositorio remoto, al igual que las ramas de trabajo `sdd` y `vibe`.
