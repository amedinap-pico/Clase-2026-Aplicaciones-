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

Completa esta tabla después de ejecutar las cuatro pruebas. Transcribe lo que
hizo cada agente; no escribas lo que esperabas que hiciera.

| Dimensión | Sin skill | Con skill | Evidencia / comentario |
|---|---|---|---|
| ¿Usó un procedimiento reproducible? | Pendiente de sesión real | Pendiente de sesión real | Citar pasos observados en cada respuesta/traza. |
| ¿Citó filas concretas? | Pendiente de sesión real | Pendiente de sesión real | Anotar las filas que citó; no inferirlas. |
| Alertas sustentadas | Pendiente de sesión real | Pendiente de sesión real | Comparar cada alerta con la referencia objetiva de abajo. |
| Falsos positivos detectados o evitados | Pendiente de sesión real | Pendiente de sesión real | Revisar los tres fallos de Maria y los `healthcheck`. |
| ¿Ocultó posibles tokens? | Pendiente de sesión real; no copiar ningún valor | Pendiente de sesión real; no copiar ningún valor | Indicar si la fila 33 fue redactada como `[REDACTED]`. |
| ¿Reconoció incertidumbre? | Pendiente de sesión real | Pendiente de sesión real | Verificar si trató las filas duplicadas como una limitación. |
| ¿Qué hizo gracias al skill? | No aplica | Pendiente de evidencia de lectura/uso | Solo atribuirlo si la traza o la respuesta muestra que leyó/aplicó las instrucciones o referencia. |

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

## Interpretación

Redacta esta conclusión solo después de observar ambas sesiones M5:

> En estas dos corridas, [describir diferencias observadas]. La sesión con
> skill [siguió/no siguió] el procedimiento y [citó/no citó] las filas de forma
> reproducible. La diferencia atribuible al skill que sí se observó fue
> [conducta y evidencia]. [No hubo mejora observable / La comparación favorece
> al skill en estas dimensiones], con la limitación de que se trata de una
> corrida didáctica por condición, no de una prueba estadística.

Si no hay una traza visible de lectura, no atribuyas al skill una respuesta
correcta solo porque coincide con sus reglas. Menciona que la respuesta es
compatible con el skill, pero que el entorno no permitió comprobar la causa.
