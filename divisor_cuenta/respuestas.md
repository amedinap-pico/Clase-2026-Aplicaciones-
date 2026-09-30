# Respuestas — Participación Semana 7

> Borrador actualizado con la evidencia disponible en el repositorio. Las respuestas marcadas como pendientes requieren datos personales o verificaciones que este entorno no permitió completar. La entrega pide que este archivo quede en `main`.

## 1. Comparación de las ramas

**Agente:** Codex. La variante exacta del modelo y el nivel de razonamiento no aparecen en los commits, por lo que debo completarlos desde la configuración de mi sesión. **Instrucciones:** `AGENTS.md` en la raíz de `divisor_cuenta`. **Caso Git:** C; `git rev-parse --show-toplevel` devuelve `C:/Clase 2026 Aplicaciones/Clase-2026-Aplicaciones-`, una carpeta que contiene más proyectos. `main`, `vibe` y `sdd` comparten el commit inicial `47017254f40ecfd15cbe6bfa02bb6e39555e630e`.

| Métrica | vibe | sdd |
|---|---:|---:|
| Iteraciones del estudiante | Pendiente: no hay registro completo de la conversación original | Pendiente: no hay registro completo de la conversación original |
| Escenarios de aceptación | Pendiente: falta probar los seis manualmente | Seis casos de dominio escritos; cuatro resultados válidos y dos errores también pasaron una comprobación Dart directa. La suite Flutter no se pudo ejecutar aquí. |
| Pruebas automatizadas que pasan | Pendiente: no se ejecutó la suite en esta rama | Según el reporte de la estudiante, las pruebas de `sdd` pasaron en su terminal; no se conservó aquí la salida del comando. |
| Archivos Dart en `lib/` | 1 | 11 |
| Líneas Dart en `lib/` | 354 | 221 |
| `domain/` depende de Flutter | Sí: la lógica está en `lib/main.dart` junto con Flutter | No: `rg "package:flutter" lib/domain` no devuelve coincidencias. |
| Separación presentation/domain/data | No | Sí |
| ¿Agregó algo que nadie pidió? | No se identificó funcionalidad de producto adicional | No se identificó funcionalidad adicional; las estrategias y artefactos SDD se piden en la guía. |
| ¿Se puede agregar una estrategia sin modificar el cálculo? | No hay estrategia separada | Sí: `CalcularDivision` recibe `EstrategiaRedondeo`; las implementaciones están en `lib/data/`. |
| Tiempo aproximado | No registrado | No registrado |

La rama `sdd` hace explícitos los requisitos, las validaciones, los modos de redondeo y las capas. En `vibe`, el pedido inicial breve dejó esas decisiones al agente. No puedo reconstruir el número de iteraciones ni asegurar que se usó exactamente el mismo modelo y configuración en ambas ramas.

## 2. Pruebas de `sdd` en `vibe`

Pendiente. No cambié a `vibe` porque el repositorio Git está en la carpeta superior que contiene otros trabajos y tiene cambios ajenos en el árbol. Flutter no pudo escribir en `C:\flutter\flutter\bin\cache` desde este agente; por ello no puedo informar si las pruebas compilaron en `vibe` ni pegar un error de compilación observado. La estudiante informa que las pruebas de `sdd` pasaron; los escenarios de `vibe` todavía no se comprobaron aquí.

## 3. Verificaciones SOLID

En el código actual de `sdd`, `domain` no importa Flutter. La estrategia es una interfaz de un método; el caso de uso no pregunta el tipo de estrategia ni contiene validación o formato. `main.dart` crea `RedondeoExacto` y `RedondeoHaciaArriba`. El analizador Dart informó `No issues found` para `lib` y `test`.

La rama `vibe` concentra pantalla y lógica en `lib/main.dart`: no tiene capas de dominio ni contrato de estrategia, por lo que SRP, OCP, ISP y DIP no quedan demostrados; LSP no aplica porque no hay implementaciones sustituibles. Falta ejecutar y guardar las salidas comparables de las búsquedas de la Parte 9.5 para ambas ramas.

La Constitution registra los cinco principios SOLID. Sin embargo, su texto SRP y los artefactos `plan.md`/`tasks.md` todavía describen la implementación anterior de propinas 10/15/20. Deben alinearse con la spec de Semana 7 antes de declarar completa la revisión SDD.

## 4. Clarificaciones

No encontré una transcripción de `/speckit-clarify`, así que no puedo inventar qué preguntas hizo. La spec define explícitamente el botón Calcular, el porcentaje ingresado, el modo exacto o hacia arriba, los mensajes de error y los seis escenarios. En `vibe`, esas decisiones se dejaron al agente salvo que la estudiante recuerde haberlas especificado en la conversación original.

## 5. Diferencias entre ramas

La comparación de commits muestra que `sdd` agregó Spec Kit, especificación, plan, tareas y separación por capas; `vibe` tiene una implementación monolítica de 354 líneas en `lib/main.dart`. No identifiqué una función de producto fuera del alcance. El `git diff --stat` final debe volver a capturarse después de consolidar los cambios actuales.

## 6. Otra herramienta SDD y cuándo elegir vibe

OpenSpec organiza cada cambio como una propuesta con especificaciones incrementales, diseño y tareas. Al archivarlo, integra los cambios de requisitos en las especificaciones principales y conserva la carpeta del cambio como historial. Lo preferiría en un proyecto de equipo con especificaciones vivas y varios cambios revisables en paralelo. [Documentación oficial de OpenSpec](https://openspec.dev/docs/quickstart) y [conceptos y archivo](https://github.com/Fission-AI/OpenSpec/blob/main/docs/concepts.md).

Elegiría vibe para explorar en pocas horas un prototipo desechable de una pantalla, cuando todavía se está definiendo el problema y se acepta rehacerlo. No lo elegiría como única documentación para una funcionalidad de producción que varias personas deban mantener.

## Pendiente antes de entregar

- Completar modelo/configuración e iteraciones a partir de la sesión real.
- Alinear `plan.md`, `tasks.md` y la Constitution con la spec de Semana 7. La edición de esos archivos fue rechazada por el revisor automático porque no pudo acceder al modelo de revisión.
- Guardar la salida de `flutter test` informado como exitoso y ejecutar/comprobar `flutter analyze` y `flutter build apk --debug`. Este agente no puede escribir en `C:\flutter\flutter\bin\cache`; `dart analyze lib test` sí terminó con `No issues found`.
- Ejecutar las mismas pruebas y los seis escenarios manuales en `vibe`, completar la evidencia de Parte 10 y restaurar `test/` a su estado original.
- Mover este borrador a `main` y subir las tres ramas después de aislar el repositorio de los otros proyectos. No se hizo `checkout`, commit ni push para evitar alterar el repositorio compartido.
