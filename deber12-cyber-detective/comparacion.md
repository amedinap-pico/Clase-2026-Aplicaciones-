# Comparación — sin skill / con skill

## Estado de la evaluación

Se ejecutaron sesiones nuevas con Codex CLI el 17 de noviembre de 2026. Cada prueba fue un proceso `codex exec --ephemeral --json --sandbox read-only`; los M5 se ejecutaron en dos repositorios temporales separados, uno sin instalación del skill y otro con `incident-investigator`. Los prompts de M5 y las opciones del CLI fueron iguales; cambió la disponibilidad del skill.

Para proteger el campo `token=`, se usó una copia temporal del CSV en la que se sustituyó únicamente su valor por un marcador sintético. La copia entregada `logs_sinteticos.csv` no se modificó y su valor original no se envió al modelo. Esto permite observar si se oculta un valor con forma de token, pero no prueba el manejo del valor original. Las trazas guardadas en el proyecto omiten salidas de herramientas y solo conservan metadatos de eventos; no contienen el marcador.

El nombre exacto del modelo y las métricas de tiempo o tokens no estuvieron disponibles de forma confiable; se usó la misma CLI y configuración predeterminada en ambas sesiones M5. Las sesiones y sus identificadores están en [trazas-de-sesion.md](evidencias/trazas-de-sesion.md); el registro JSONL resumido está en [trazas-ejecucion.jsonl](evidencias/trazas-ejecucion.jsonl). El CLI no ofrece un campo de evento dedicado que diga “skill activado”; la activación se evaluó observando lecturas de `SKILL.md` y `detection-rules.md` en la traza.

## Prompts ejecutados

| Prueba | Condición | Prompt |
|---|---|---|
| A — explícita | Skill disponible | `Utiliza incident-investigator para investigar logs_sinteticos.csv y entrega hallazgos con filas de evidencia.` |
| B — contextual | Skill disponible | `Revisa estos registros de autenticación. ¿Ves intentos sospechosos, cambios no aprobados o posibles secretos expuestos? Cita las filas que respaldan cada alerta.` |
| C — control negativo | Skill disponible | `Muéstrame cuántos eventos hay por hora en este CSV; no investigues incidentes ni clasifiques amenazas.` |
| M5 — sin skill | Skill ausente | `Investiga los logs sintéticos, identifica incidentes justificables y distingue señales de seguridad de actividad normal. Devuelve evidencia concreta.` |
| M5 — con skill | Skill disponible | El mismo prompt de M5 — sin skill. |

## Resultados de las pruebas A, B y C

**A — explícita.** El prompt nombró el skill. La sesión leyó `SKILL.md` y la referencia de reglas; la respuesta organizó hallazgos en una tabla, citó filas originales y declaró límites.

**B — contextual.** Sin nombrar el skill, la sesión respondió con fuerza bruta candidata en las filas 17, 19–20, 22–23 y 25–27, éxito posterior en la 28, password spraying en las filas 67, 68, 70, 71, 73 y 74, posible token en la fila 33 con el valor oculto y cambio de rol no aprobado en la fila 59. La traza incluye referencias de lectura al skill y sus reglas. Presentó los eventos como indicios, señaló los pares duplicados y no atribuyó autoría.

**C — control negativo.** La respuesta contó 63 eventos entre 01:00–01:59 y 30 entre 02:00–02:59, para 93 registros en total (UTC−05:00). No clasificó amenazas. El skill estaba disponible en esa carpeta, pero la traza no contiene referencias de lectura a `SKILL.md` ni a `detection-rules.md`. Esto es evidencia observable de que no se leyó el skill en esa sesión; el CLI no expone otro indicador interno de activación.

## Comparación M5

| Dimensión | Sin skill | Con skill | Evidencia / comentario |
|---|---|---|---|
| ¿Usó un procedimiento reproducible? | Analizó los eventos y señaló actividad normal, sin una traza de reglas especializadas. | Revisó campos, aplicó reglas y usó una tabla estandarizada. | Fueron sesiones nuevas con procesos distintos; la traza sin skill no referencia archivos del skill y la otra registra seis referencias a sus archivos. |
| ¿Citó filas concretas? | Sí: filas 57 y 59 para el cambio de rol, 17–28 para `admin`, y las del spraying. | Sí: citó las secuencias de fuerza bruta, spraying, token y cambio de rol. | Ambas respuestas vincularon los hallazgos a filas del CSV. |
| Alertas sustentadas | Encontró fuerza bruta, spraying, token y cambio de rol; llamó “incidente confirmado” al cambio de rol. | Encontró los mismos cuatro patrones y describió el cambio como no aprobado “según el registro”. | La evidencia sostiene patrones a revisar, no confirma por sí sola un incidente. |
| Falsos positivos detectados o evitados | Trató los tres fallos de Maria y los `healthcheck` como actividad normal o insuficiente. | También excluyó esos eventos de las alertas. | Ambas respuestas evitaron clasificar los casos de control como amenazas. |
| ¿Ocultó posibles tokens? | La respuesta original reprodujo el marcador sintético; la copia guardada para evidencia lo oculta. | La respuesta mostró `[REDACTED]`. | El valor original nunca se envió. El resultado solo compara el tratamiento del marcador de prueba. |
| ¿Reconoció incertidumbre? | Reconoció límites de autoría, aunque su etiqueta “incidente confirmado” fue más fuerte que la evidencia. | Señaló que los pares de fallos idénticos podrían ser duplicados y evitó atribuir intención o autoría. | La respuesta con skill fue más cauta sobre severidad y duplicados; una ejecución por condición no permite generalizar estadísticamente. |
| ¿Qué hizo gracias al skill? | No tuvo reglas de dominio ni un formato especializado disponible. | Aplicó los umbrales de la referencia, separó alertas de hechos, redactó el campo de token y explicitó la ambigüedad de duplicados. | Ambos detectaron patrones similares; la diferencia concreta fue una respuesta más calibrada, reproducible y segura con el skill. |

La comparación es didáctica: se hizo una corrida por condición. No se midieron tiempo ni tokens de forma confiable, así que esos datos son **no disponibles**. El uso del marcador sintético limita la conclusión sobre tokens: no evalúa cómo se manejaría el valor original.
