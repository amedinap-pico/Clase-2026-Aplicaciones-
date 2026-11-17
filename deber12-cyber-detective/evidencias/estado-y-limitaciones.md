# Estado de pruebas y limitaciones

## Resultado actualizado

El 17 de noviembre de 2026 se completaron sesiones independientes para las pruebas A, B, C y M5. Cada resultado citado abajo proviene de un proceso nuevo de Codex CLI con `--ephemeral --json`; los identificadores y metadatos observables están en [trazas-de-sesion.md](trazas-de-sesion.md) y [trazas-ejecucion.jsonl](trazas-ejecucion.jsonl).

La revisión automática bloqueó el envío del CSV original porque la fila 33 contiene un valor detrás de `token=`. Las sesiones usaron copias temporales donde solo ese valor se sustituyó por un marcador sintético. El archivo entregado `logs_sinteticos.csv` no se modificó y el valor original no se envió al modelo. Por eso la evaluación de redacción mide el manejo del marcador sintético, no del valor original.

El CLI no ofrece un evento explícito de activación del skill. Para B y M5 con skill, la traza muestra lecturas de `SKILL.md` o `detection-rules.md`. Para C, el skill estuvo disponible pero no hay lecturas de esos archivos y la respuesta se limitó al conteo. La conclusión de no activación en C se limita a lo observable en esa traza.

## Estado de las pruebas

| Prueba | Estado | Evidencia |
|---|---|---|
| A — activación explícita | Ejecutada en sesión nueva | La respuesta indicó que siguió `incident-investigator`, citó filas y limitaciones; la traza registra lecturas del skill. |
| B — activación contextual | Ejecutada en sesión nueva | Identificó patrones en filas 17–28, 67–74, 33 y 59. La traza registra lecturas del skill. |
| C — control negativo | Ejecutada en sesión nueva | Contó 63 eventos en 01:00 y 30 en 02:00, sin clasificar amenazas. El skill estaba disponible y no hay referencias de lectura en la traza. |
| Comparación M5 sin/con skill | Ejecutada en dos sesiones nuevas | Ambas respuestas y sus diferencias se describen en `comparacion.md`; cada condición tiene un identificador de sesión distinto. |

## Límites de la comparación

- Se hizo una corrida por condición. Los resultados ilustran esas respuestas y no permiten una conclusión estadística.
- El valor original detrás de `token=` no se compartió con el modelo. El marcador sintético permitió evaluar si la respuesta lo ocultaba, pero la corrida no verifica el comportamiento ante el valor original.
- En la condición sin skill, la respuesta M5 calificó el cambio de rol como “incidente confirmado”; la respuesta con skill lo describió como no aprobado según el registro y separó el indicio de una conclusión forense.
- El resumen conservado en el repositorio filtra las trazas JSONL para excluir salidas de herramientas, el marcador y rutas locales. Las respuestas completas se mantuvieron temporalmente; no se agregaron respuestas sin revisar.

## Intentos fallidos que no cuentan como pruebas

Los primeros intentos fallaron antes de producir respuestas porque la terminal no tenía definida `HOME`. También falló una ejecución de control desde una carpeta temporal a la que el CLI no pudo acceder. Después se definió `HOME` para el proceso y se usaron carpetas de trabajo compatibles con el sandbox; solo las cinco sesiones válidas listadas en la traza se usan como evidencia. No se fabricaron capturas ni salidas.
