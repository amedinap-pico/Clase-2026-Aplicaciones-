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
| B — activación contextual | Parcial, no aislada | El skill apareció en la lista de disponibles mientras el usuario pidió terminar la entrega sin nombrarlo. El contexto anterior ya trataba el skill; por ello no demuestra autoactivación contextual en una sesión independiente. |
| C — control negativo | No comprobable en esta sesión | No se hizo una sesión nueva con el prompt de conteo. No se afirma que el control haya evitado una activación. |
| Comparación sin skill / con skill | Pendiente | No hay dos sesiones independientes. `comparacion.md` deja explícito que los resultados no se midieron. |

Para completar B, C y la comparación, inicia sesiones nuevas con y sin el skill,
conserva sus respuestas o trazas reales y reemplaza los estados pendientes. La
lectura manual de archivos no sustituye esas pruebas. No se fabricaron capturas,
invocaciones ni resultados.
