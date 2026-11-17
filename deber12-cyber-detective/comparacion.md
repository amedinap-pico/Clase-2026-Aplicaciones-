# Comparación — sin skill / con skill

## Estado de la evaluación

La comparación experimental todavía está pendiente. En la preparación de esta
sesión se encontró Codex CLI, pero las cuatro invocaciones (`B`, `C`, `M5 sin
skill`, `M5 con skill`) terminaron antes de crear una sesión porque esa terminal
devolvió `Error finding codex home: Could not find home directory`. No se obtuvo
ninguna respuesta de modelo de esas invocaciones. No se rellenan resultados
supuestos ni se usan los análisis anteriores como corridas independientes.

Para Codex, el skill de proyecto está en `.agents/skills/incident-investigator/`.
La prueba requiere chats nuevos en el workspace correcto; cada chat conserva su
propio transcript. La IDE usa la carpeta abierta como contexto local. En la
CLI, `codex exec --json` permite guardar eventos JSONL cuando el ejecutable
puede iniciar sesión correctamente. Véase [estado de trazas](evidencias/estado-y-limitaciones.md).

## Preparar las condiciones

En PowerShell, desde cualquier carpeta dentro del repositorio, crea dos
directorios temporales. El de control contiene solo el CSV; el otro contiene el
mismo CSV y la copia del skill usada por Codex. No abras una sesión antes de
prepararlos.

```powershell
$repo = (git rev-parse --show-toplevel | Select-Object -First 1).Trim()
$project = Join-Path $repo 'deber12-cyber-detective'
$runRoot = Join-Path $env:TEMP ('cyber-detective-eval-' + [guid]::NewGuid().ToString('N'))
$sinSkill = Join-Path $runRoot 'sin-skill'
$conSkill = Join-Path $runRoot 'con-skill'
New-Item -ItemType Directory -Force -Path $sinSkill, $conSkill | Out-Null

Copy-Item -LiteralPath (Join-Path $project 'logs_sinteticos.csv') -Destination $sinSkill
Copy-Item -LiteralPath (Join-Path $project 'logs_sinteticos.csv') -Destination $conSkill

$skillDestino = Join-Path $conSkill '.agents\skills\incident-investigator'
New-Item -ItemType Directory -Force -Path (Join-Path $skillDestino 'references') | Out-Null
Copy-Item -LiteralPath (Join-Path $project '.agents\skills\incident-investigator\SKILL.md') -Destination $skillDestino
Copy-Item -LiteralPath (Join-Path $project '.agents\skills\incident-investigator\references\detection-rules.md') -Destination (Join-Path $skillDestino 'references')

$hashSin = (Get-FileHash (Join-Path $sinSkill 'logs_sinteticos.csv') -Algorithm SHA256).Hash
$hashCon = (Get-FileHash (Join-Path $conSkill 'logs_sinteticos.csv') -Algorithm SHA256).Hash
"El CSV es idéntico en ambas carpetas: $($hashSin -eq $hashCon)"
```

En la IDE, abre cada directorio como carpeta/workspace y crea un chat nuevo
para cada ejecución. En `sin-skill`, comprueba que `incident-investigator` no
aparezca en las skills disponibles; si aparece por una instalación de usuario,
esa condición no es válida. En `con-skill`, comprueba que sí aparezca. No
incluyas `hallazgos.md`, respuestas anteriores ni el skill en la carpeta de
control.

Haz cada prompt en un chat separado, sin continuar otro chat:

| Prueba | Carpeta | Prompt exacto |
|---|---|---|
| B — contextual | `con-skill` | `Revisa estos registros de autenticación. ¿Ves intentos sospechosos, cambios no aprobados o posibles secretos expuestos? Cita las filas que respaldan cada alerta.` |
| C — control negativo | `con-skill` | `Muéstrame cuántos eventos hay por hora en este CSV; no investigues incidentes ni clasifiques amenazas.` |
| M5 — sin skill | `sin-skill` | `Investiga los logs sintéticos, identifica incidentes justificables y distingue señales de seguridad de actividad normal. Devuelve evidencia concreta.` |
| M5 — con skill | `con-skill` | `Investiga los logs sintéticos, identifica incidentes justificables y distingue señales de seguridad de actividad normal. Devuelve evidencia concreta.` |

Para la comparación M5 mantén el mismo modelo, ajustes y prompt; la única
condición que debe cambiar es la presencia del skill. Guarda las respuestas y
las trazas reales. Si usas `codex exec --json`, cada llamada debe ser un proceso
nuevo y su salida JSONL debe guardarse en un archivo aparte. Revisa y redacta
cualquier `token=` en una copia antes de agregar evidencia al PR; conserva las
trazas originales solo en una ubicación temporal privada.

## Resultados observados

No se obtuvo una respuesta de Codex para B, C ni M5: las invocaciones locales
terminaron antes de crear una sesión. Por eso la tabla evalúa honestamente el
estado actual como **no evaluable**, no como una comparación completada. El
conteo local de C se incluye aparte como comprobación de los datos, no como
prueba de que Codex evitó activar el skill.

| Dimensión | Sin skill | Con skill | Evidencia / comentario |
|---|---|---|---|
| ¿Usó un procedimiento reproducible? | No evaluable: no se inició una sesión sin skill. | No evaluable: no se inició una sesión con skill. | Las cuatro llamadas terminaron con `Could not find home directory` antes de obtener respuesta. |
| ¿Citó filas concretas? | No evaluable: no hay respuesta del agente. | No evaluable: no hay respuesta del agente. | No atribuir a estas condiciones las filas citadas en el análisis previo. |
| Alertas sustentadas | No evaluable: no hay respuesta del agente. | No evaluable: no hay respuesta del agente. | Usar la referencia objetiva de abajo para puntuar las corridas futuras. |
| Falsos positivos detectados o evitados | No evaluable: no hay respuesta del agente. | No evaluable: no hay respuesta del agente. | Revisar si cada respuesta excluye los tres fallos de Maria y `healthcheck`. |
| ¿Ocultó posibles tokens? | No evaluable: no hay respuesta del agente. | No evaluable: no hay respuesta del agente. | No se reproduce el valor de la fila 33. |
| ¿Reconoció incertidumbre? | No evaluable: no hay respuesta del agente. | No evaluable: no hay respuesta del agente. | Revisar si cada respuesta trata los pares idénticos como una limitación. |
| ¿Qué hizo gracias al skill? | No aplica. | No evaluable: no hubo sesión con skill ni traza de lectura. | La disponibilidad del skill en otra conversación no demuestra su uso en estas corridas. |

## Resultados de B y C

| Prueba | Resultado | Qué demuestra / qué no demuestra |
|---|---|---|
| B — contextual | Se revisaron los datos del CSV en esta conversación: fuerza bruta candidata, spraying, marcador de token y cambio de rol con las filas listadas en la referencia. | Confirma las filas del archivo, pero el contexto de esta conversación ya contenía análisis del skill. No es una sesión limpia y no demuestra que el skill se activara por su `description`. |
| C — control negativo | El conteo local de PowerShell dio 63 eventos en 01:00 y 30 en 02:00 (UTC−05:00), 93 en total. | Confirma los datos del CSV. No prueba que Codex no activó el skill, porque la cuenta la hizo PowerShell y las invocaciones de Codex fallaron antes de iniciar. |

## Referencia objetiva del CSV para calificar las respuestas

Estos son resultados verificados contra el CSV original; **no son respuestas de
las sesiones comparadas**:

- Fuerza bruta probable por conteo de registros: filas 17, 19, 20, 22, 23, 25,
  26 y 27, entre 01:14 y 01:18; éxito posterior en fila 28. Las parejas 19/20,
  22/23 y 25/26 son idénticas. Si fueran duplicados de ingesta quedarían cinco
  registros distintos, por lo que el informe debe conservar esa incertidumbre.
- Password spraying probable: filas 67, 68, 70, 71, 73 y 74, seis usuarios
  distintos de una IP dentro de la ventana.
- Posible exposición de token: fila 33. No reproducir su valor; usar
  `[REDACTED]`.
- Cambio de rol con `approved=false`: fila 59.
- Las filas 38, 39 y 41 son tres fallos de Maria, menos que el umbral de seis;
  la fila 42 es un éxito posterior, no convierte los tres fallos en fuerza
  bruta. Los `healthcheck` de las filas 78 y 80–84 no son `login/failed`.
- Para el control descriptivo C, el conteo de referencia es 63 eventos en la
  hora 01:00 y 30 en la hora 02:00 (UTC−05:00).

## Conclusión actual

No se puede afirmar una mejora ni una diferencia entre condiciones: no hubo
salidas válidas de M5. El conteo de C sí está comprobado contra el CSV, pero no
es una respuesta de Codex y no prueba la no activación del skill. El análisis de
`hallazgos.md` sirve como referencia de filas, no como salida de una corrida
con o sin skill. Por ello, esta evaluación no demuestra experimentalmente el
aporte del skill; las respuestas y trazas de las sesiones nuevas deben
incorporarse cuando se ejecuten en la IDE.

Incluso con una corrida válida por condición, la comparación será didáctica y
no estadística. Si no hay una traza visible de lectura, no atribuyas al skill
una respuesta correcta solo porque coincide con sus reglas; declara esa
incertidumbre.
