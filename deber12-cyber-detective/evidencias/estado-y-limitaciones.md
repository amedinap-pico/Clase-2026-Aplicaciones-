# Estado de pruebas y limitaciones

Este registro distingue la lectura manual de los archivos de una activación
automática del skill. Es una traza textual de esta sesión, no una captura ni una
prueba de que Codex haya activado el skill por su `description`.

## Lo observado en esta sesión

- El agente leyó `incident-investigator/SKILL.md` y
  `incident-investigator/references/detection-rules.md` con `Get-Content` tras
  recibir la solicitud de completar el enunciado. Esta lectura permitió aplicar
  sus instrucciones al informe, pero no fue una invocación aislada con el prompt
  de la Prueba A.
- El skill no aparece en la lista de skills disponibles que recibió esta
  sesión. Por ello no se observó un evento de autoactivación contextual.
- Después de revisar los archivos, se preparó una copia en
  `.agents/skills/incident-investigator/` para que pueda descubrirse como
  skill de proyecto en una sesión nueva; esta sesión no recargó su catálogo.
- Se copió `logs_sinteticos.csv` desde `Downloads` al proyecto. El SHA-256 de la
  copia coincide con el original. El CSV tiene 93 registros y el encabezado
  esperado; el valor de `token=` nunca se mostró.
- Se comprobaron manualmente las filas 38, 39, 41, 42 y 59. Las filas 38, 39 y
  41 son tres `login/failed` de Maria; la fila 42 es un éxito posterior; la fila
  59 registra `role_change/success` con `approved=false`.

### Continuación del 17 de noviembre de 2026

En esta continuación, el entorno presentó `incident-investigator` en su lista
de skills disponibles, desde `.agents/skills/incident-investigator/SKILL.md`.
El agente aplicó el procedimiento leído previamente para completar la
investigación y revisar la entrega. Esto es evidencia de disponibilidad y uso
del skill en esta conversación. Como el contexto ya contenía la tarea, el skill
y el análisis previo, no es una sesión limpia para la prueba contextual, la
prueba explícita aislada ni la comparación.

## Estado de las pruebas solicitadas

| Prueba | Estado | Evidencia disponible |
|---|---|---|
| A — activación explícita | Parcial | El entorno presentó el skill y sus instrucciones se aplicaron al CSV. No se ejecutó el prompt sugerido en una invocación separada ni se observó una traza de lectura nueva del runtime. |
| B — activación contextual | No evaluable | Las invocaciones nuevas de Codex desde esta terminal fallaron antes de iniciar una sesión. El análisis previo no es independiente ni demuestra autoactivación. |
| C — control negativo | Conteo de datos verificado; activación no evaluada | PowerShell contó 63 eventos a la hora 01:00 y 30 a la hora 02:00 (UTC−05:00), 93 en total. Codex no respondió; el conteo no demuestra que el skill no se activó. |
| Comparación sin skill / con skill | No evaluable | No hubo respuestas del modelo en ninguna de las condiciones independientes. `comparacion.md` no atribuye resultados a una corrida inexistente. |

Para completar B, C y la comparación, inicia sesiones nuevas con y sin el skill,
conserva sus respuestas o trazas reales y reemplaza los estados pendientes. La
lectura manual de archivos no sustituye esas pruebas. No se fabricaron capturas,
invocaciones ni resultados.

## Intento de ejecución CLI desde esta terminal

Se encontró Codex CLI `0.169.0-alpha.11.1`. Sin embargo, las cuatro llamadas
preparadas con `codex exec --json` terminaron antes de iniciar un agente con el
error `Error finding codex home: Could not find home directory`. En este proceso
`HOME` no estaba definido; `USERPROFILE` sí estaba definido. No se generaron
respuestas de modelo ni trazas de sesiones B, C o M5. Este error describe esta
terminal auxiliar; no demuestra que la IDE de Codex de la usuaria carezca de
trazas o no pueda iniciar esas sesiones. Los estados de la tabla anterior siguen
pendientes hasta ejecutarlos en la IDE con chats nuevos.

## Revisión de datos de esta solicitud

Se volvieron a comprobar en modo de solo lectura las filas 17, 19, 20, 22, 23,
25, 26 y 27; las parejas 19/20, 22/23 y 25/26 son idénticas. También se
confirmaron las filas 67, 68, 70, 71, 73 y 74; marcador `token=` en fila 33
(valor suprimido); `role_change/success` con `approved=false` en fila 59; y los
tres fallos de Maria en 38, 39 y 41. El conteo horario se comprobó por separado
con PowerShell: 63 eventos en 01:00 y 30 en 02:00 (UTC−05:00). Esta revisión
confirma los datos del CSV, pero no es una sesión independiente de Codex ni
prueba activación o no activación del skill.
