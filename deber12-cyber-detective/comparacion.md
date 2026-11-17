# Comparación — sin skill / con skill

## Alcance de esta comparación

El CSV se analizó después de leer manualmente el procedimiento y las reglas de
`incident-investigator`. En la continuación, el skill apareció en el catálogo
del runtime y sus instrucciones se aplicaron a esta tarea. No se ejecutaron dos
sesiones independientes con el mismo agente/modelo. Por lo tanto, esta tabla
separa lo observado en el análisis guiado de lo que no se puede afirmar sobre
el rendimiento experimental sin skill. No se inventan salidas ni trazas de
sesiones.

| Dimensión | Sin skill | Con skill | Evidencia / comentario |
|---|---|---|---|
| ¿Usó un procedimiento reproducible? | No observado: no se hizo una sesión de control | Sí, tras leer manualmente las reglas; el runtime listó el skill en la continuación | CSV con encabezado en fila 1; reglas aplicadas según [hallazgos.md](hallazgos.md). La lista de skills y la lectura manual no equivalen a dos sesiones independientes. |
| ¿Citó filas concretas? | No observado | Sí, para cada alerta y para el ejemplo de tres fallos | Fuerza bruta: filas 17, 19, 20, 22, 23, 25–27 y éxito en 28; spraying: 67, 68, 70, 71, 73–74; token: 33; rol: 59; tres fallos: 38, 39, 41 y éxito: 42. |
| Alertas sustentadas | No evaluado | 4 patrones de alerta según las reglas; la fuerza bruta lleva una salvedad material por posibles filas duplicadas | Filas de fuerza bruta, spraying, token y cambio de rol descritas en [hallazgos.md](hallazgos.md). Son alertas basadas en logs, no conclusiones forenses. |
| Falsos positivos detectados o evitados | No observado | Sí: tres fallos de Maria no alcanzan seis; `healthcheck` no se contó como login fallido | Filas 38, 39, 41 y 78, 80–84. |
| ¿Ocultó posibles tokens? | No observado | Sí: el informe usa únicamente `[REDACTED]` | Fila 33, `detail` redactado en [hallazgos.md](hallazgos.md); el valor no se reproduce. |
| ¿Reconoció incertidumbre? | No observado | Sí: señaló filas idénticas en la secuencia de fallos y limitaciones sobre interpretación, causalidad e identidad | En particular, los pares idénticos 19/20, 22/23 y 25/26 podrían alterar el umbral si fueran duplicados de ingesta. |
| ¿Qué hizo gracias al skill? | No se puede comparar sin la sesión de control | El análisis siguió el formato, los umbrales y los límites definidos por el skill; su efecto frente a una sesión sin skill no está medido | La mejora concreta en la comparación requiere repetir la misma solicitud en dos sesiones independientes y guardar ambas respuestas/trazas. |

## Resultado honesto

Esta ejecución muestra cómo queda un análisis cuando el agente ha leído y sigue
las instrucciones del skill. En la continuación, Codex incluyó el skill en su
catálogo. Esto demuestra disponibilidad en ese turno, pero no mide una mejora
frente a una sesión sin él ni demuestra autoactivación contextual.
Para completar la evaluación solicitada, conserva este CSV y la misma petición,
ejecuta una sesión nueva sin cargar ningún archivo del skill y otra con el skill
disponible. Reemplaza «No observado» solo con evidencia de esas sesiones. Si la
plataforma no ofrece trazas, describe lo que viste y separa explícitamente las
inferencias.
