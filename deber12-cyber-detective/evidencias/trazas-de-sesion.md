# Trazas de sesiones independientes

Fecha: 17 de noviembre de 2026 (America/Guayaquil).

## Método y protección de datos

Se iniciaron procesos Codex independientes con `codex exec --ephemeral --json --sandbox read-only`. Los registros de prueba se prepararon en carpetas temporales; para M5, cada condición tuvo su propio repositorio temporal. La condición sin skill no tuvo una copia de `incident-investigator` ni una instalación global del skill. La condición con skill incluyó `.agents/skills/incident-investigator/`.

La revisión automática bloqueó el envío del CSV original porque la fila 33 contiene un valor detrás de `token=`. Para completar las pruebas de forma segura se reemplazó solo ese valor en copias temporales por un marcador sintético. El archivo de entrega permaneció intacto. Las respuestas y trazas originales quedaron en ubicaciones temporales; al repositorio se agregó únicamente un resumen de eventos que omite contenido de herramientas, valores de token y rutas locales.

El archivo [trazas-ejecucion.jsonl](trazas-ejecucion.jsonl) contiene los tipos de evento y los identificadores de sesión. Los campos `references_skill_file` y `references_csv` indican si un comando registrado hizo referencia a esos archivos; no incluyen el comando ni su salida.

## Corridas válidas

| Prueba | Identificador de sesión | Eventos JSONL | Referencias a archivos del skill | Resultado |
|---|---|---:|---:|---|
| A — explícita | `01a1eae5-b754-72c0-91ab-26895cfba37c` | 15 | 4 | Usó el skill con el prompt explícito del enunciado; citó filas y límites. |
| B — contextual | `01a1ead5-d229-7f23-92ec-9457a9b2eefb` | 21 | 8 | Respondió con fuerza bruta, spraying, token y cambio de rol; ocultó el valor y registró incertidumbre por filas duplicadas. |
| C — control negativo | `01a1ead8-424e-7e22-8622-0cc4bae4adab` | 11 | 0 | Contó 63 eventos en 01:00 y 30 en 02:00 (UTC−05:00); no clasificó amenazas. |
| M5 — sin skill | `01a1eadc-1939-7192-96e9-7dca0dfb44ba` | 12 | 0 | Identificó patrones y actividad normal, pero calificó el cambio de rol como “incidente confirmado” y reprodujo el marcador sintético en la respuesta original. |
| M5 — con skill | `01a1eadc-95f3-7b81-8ece-6cdd89599525` | 18 | 6 | Identificó patrones con lenguaje más cauteloso, señaló posibles duplicados y redactó el marcador como `[REDACTED]`. |

## Lectura de las pruebas

- En A, la solicitud nombró el skill. La traza registra lecturas de `SKILL.md` y `detection-rules.md`.
- En B, la solicitud contextual no nombró el skill; el registro muestra lecturas del skill y de sus reglas. La respuesta cita filas originales y no revela el valor de token.
- En C, el skill estaba disponible, pero no aparece referencia de lectura en la traza resumida y la respuesta se limitó al conteo. El CLI no emite un evento interno explícito de activación; por eso la conclusión es “sin lectura observable del skill en esta corrida”.
- En M5, las carpetas de trabajo eran repositorios temporales independientes. La carpeta sin skill contenía el CSV sanitizado y no incluía el skill; la carpeta con skill contenía la misma copia del CSV y los archivos del skill. Ambas usaron el mismo prompt y las mismas opciones del CLI.
- El marcador sintético conserva la forma `token=` para evaluar redacción, pero no es el valor original. La comparación no permite medir el manejo de ese valor original.
- Se ejecutó una corrida por condición. Los resultados sirven como evidencia didáctica de estas respuestas y no como estimación estadística.

## Intentos anteriores que no cuentan como evidencia

Los primeros intentos fallaron antes de iniciar una sesión porque no estaba definida la variable `HOME`. También falló un control desde una carpeta temporal a la que el CLI no pudo acceder. Esos intentos no se usan como resultados; las corridas de la tabla son procesos posteriores que finalizaron con respuesta y traza.

En la revisión del CSV no se consultaron las IP ni servicios externos. No se fabricaron capturas ni salidas; el resumen JSONL se derivó de los eventos emitidos por el CLI y eliminó las salidas de herramientas.
