# Comparación — sin skill / con skill

## Estado de la evaluación

Se ejecutaron sesiones nuevas con Codex CLI el 17 de noviembre de 2026. Cada prueba fue un proceso `codex exec --ephemeral --json --sandbox read-only`; los M5 se ejecutaron en dos repositorios temporales separados, uno sin instalación del skill y otro con `incident-investigator`. Los prompts de M5 y las opciones del CLI fueron iguales; cambió la disponibilidad del skill.

Para proteger el campo `token=`, se usó una copia temporal del CSV en la que se sustituyó únicamente su valor por un marcador sintético. La copia entregada `logs_sinteticos.csv` no se modificó y su valor original no se envió al modelo. Esto permite observar si se oculta un valor con forma de token, pero no prueba el manejo del valor original. Las trazas guardadas en el proyecto omiten salidas de herramientas y solo conservan metadatos de eventos; no contienen el marcador.

Las sesiones y sus identificadores están en [trazas-de-sesion.md](evidencias/trazas-de-sesion.md); el registro JSONL resumido está en [trazas-ejecucion.jsonl](evidencias/trazas-ejecucion.jsonl). El CLI no ofrece un campo de evento dedicado que diga “skill activado”; la activación se evaluó observando lecturas de `SKILL.md` y `detection-rules.md` en la traza.

## Prompts ejecutados

| Prueba | Condición | Prompt |
|---|---|---|
| A — explícita | Skill disponible | `Usa explícitamente el skill incident-investigator para analizar logs_sinteticos.csv. Aplica sus reglas, cita las filas que sustentan cada hallazgo y redacta cualquier valor token.` |
| B — contextual | Skill disponible | `Revisa estos registros de autenticación. ¿Ves intentos sospechosos, cambios no aprobados o posibles secretos expuestos? Cita las filas que respaldan cada alerta.` |
| C — control negativo | Skill disponible | `Muéstrame cuántos eventos hay por hora en este CSV; no investigues incidentes ni clasifiques amenazas.` |
| M5 — sin skill | Skill ausente | `Investiga los logs sintéticos, identifica incidentes justificables y distingue señales de seguridad de actividad normal. Devuelve evidencia concreta.` |
| M5 — con skill | Skill disponible | El mismo prompt de M5 — sin skill. |

## Resultados de la Prueba B y del control C

**B — contextual.** La sesión respondió con fuerza bruta candidata en las filas 17, 19–20, 22–23 y 25–27, éxito posterior en la 28, password spraying en las filas 67, 68, 70, 71, 73 y 74, posible token en la fila 33 con el valor oculto y cambio de rol no aprobado en la fila 59. La traza incluye referencias de lectura al skill y sus reglas. Presentó los eventos como indicios, señaló los pares duplicados y no atribuyó autoría.

**C — control negativo.** La respuesta contó 63 eventos entre 01:00–01:59 y 30 entre 02:00–02:59, para 93 registros en total (UTC−05:00). No clasificó amenazas. El skill estaba disponible en esa carpeta, pero la traza no contiene referencias de lectura a `SKILL.md` ni a `detection-rules.md`. Esto es evidencia observable de que no se leyó el skill en esa sesión; el CLI no expone otro indicador interno de activación.

## Comparación M5

| Dimensión | Sin skill | Con skill | Evidencia observada |
|---|---|---|---|
| Procedimiento reproducible | Sesión nueva; no había skill en el repositorio temporal ni en el perfil global. | Sesión nueva; skill instalado en `.agents/skills/incident-investigator/` y leído en la traza. | Un proceso efímero por condición, mismo prompt, mismo CSV sanitizado y opciones por defecto del mismo CLI. |
| Filas y evidencia | Citó las filas 57 y 59 para el cambio de rol, 17–28 para los intentos contra `admin`, y las filas de spraying. | Citó las mismas secuencias y especificó el detalle de cada patrón. | Ambas respuestas enlazaron sus afirmaciones a filas concretas. |
| Clasificación de alertas | Identificó los cuatro patrones, pero llamó “incidente confirmado” al cambio de rol. | Llamó a las alertas patrones probables o cambios no aprobados “según el registro”. | El skill mantuvo la distinción entre lo que indica el log y un incidente confirmado. |
| Falsos positivos | Trató los tres fallos de Maria y los `healthcheck` como actividad normal o insuficiente. | También excluyó esos eventos de las alertas. | En estas corridas ambas respuestas evitaron clasificar los casos de control como amenazas. |
| Ocultamiento del token | La respuesta original reprodujo el marcador sintético; la copia guardada para evidencia lo oculta. | La respuesta mostró `[REDACTED]`. | El valor original nunca se envió. El resultado solo compara el tratamiento del marcador de prueba. |
| Incertidumbre y límites | Reconoció límites de autoría, aunque su etiqueta “incidente confirmado” fue más fuerte que la evidencia. | Señaló que los pares de fallos idénticos podrían ser duplicados y evitó atribuir intención o autoría. | La respuesta con skill fue más cauta sobre severidad y duplicados; una ejecución por condición no permite generalizar estadísticamente. |

En esta comparación, ambas condiciones detectaron patrones similares y citaron filas. La diferencia más clara fue el cuidado al calificar el cambio de rol y al redactar el marcador de token. Es una evaluación didáctica de una corrida por condición, no una medición estadística. El resumen de las trazas registra lecturas del skill en B y M5 con skill, y ninguna lectura en C ni M5 sin skill.
