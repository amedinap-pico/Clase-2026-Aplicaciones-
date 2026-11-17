# Hallazgos — logs_sinteticos.csv

## Alcance y método

Se revisó el CSV original proporcionado en `Downloads`, sin modificarlo ni
consultar las IP. Se incluyó una copia en esta entrega; su SHA-256 coincide con
el original. El encabezado está en la fila 1 y contiene las seis columnas
esperadas: `timestamp`, `ip`, `user`, `event`, `result` y `detail`. Las
referencias siguientes usan números de fila del original, incluido el
encabezado. Se ordenaron y compararon los timestamps aplicando ventanas de
hasta 5 minutos, inclusive, y coincidencia exacta de `event`/`result`.

Las reglas sustentan alertas para revisión; no demuestran por sí solas una
intrusión, la identidad de quien actuó ni culpabilidad. La prioridad es
orientativa, ya que las reglas no definen una escala de severidad.

## Alertas justificadas

| alerta | severidad orientativa | regla | timestamp | ip | usuario | filas/evidencia | limitaciones |
|---|---|---|---|---|---|---|---|
| Fuerza bruta probable, según las filas registradas | Alta | 6 o más `login/failed` de la misma IP al mismo usuario dentro de 5 minutos | Fallos 01:14–01:18; `login/success` a las 01:19 (UTC−05:00) | `198.51.100.77` | `admin` | 8 filas de fallo: 17, 19, 20, 22, 23, 25, 26 y 27. Éxito posterior: fila 28. | Las filas 19/20, 22/23 y 25/26 son pares idénticos en todos los campos. Contando cada registro, son 8 fallos y se supera el umbral; si esos pares fueran duplicados de ingesta, quedarían 5 eventos distintos. El CSV no permite determinar cuál interpretación corresponde. El éxito ocurre dentro de los 5 minutos siguientes al último fallo, pero no demuestra causalidad. |
| Password spraying probable | Alta | Una IP con `login/failed` contra 5 o más usuarios distintos en 5 minutos | 02:01–02:03 (UTC−05:00) | `203.0.113.89` | 6 usuarios: `ana`, `carlos`, `luisa`, `diego`, `maria`, `sofia` | Filas 67, 68, 70, 71, 73 y 74; son seis usuarios distintos. | La alerta se basa en los eventos registrados; no permite atribuir intención ni confirmar quién controlaba la IP. |
| Posible token expuesto en log de depuración | Media | `detail` contiene `token=` | 01:27 (UTC−05:00) | `192.0.2.44` | `api_service` | Fila 33; campo `detail`: `token=[REDACTED]; debug output`. | El registro parece indicar que el valor es demostrativo, pero esta regla marca cualquier `token=`. No se puede verificar si sería utilizable; el valor se omite deliberadamente. |
| Cambio de rol no aprobado según el registro | Alta | `role_change/success` con `approved=false` | 01:50 (UTC−05:00) | `203.0.113.42` | `guest` | Fila 59; el detalle registra un cambio `user->admin` con `approved=false`. | Describe el contenido del log; no confirma la autorización fuera del registro, la identidad real ni culpabilidad. |

## Los tres fallos de Maria no son fuerza bruta

La inspección directa de las filas originales 38, 39 y 41 confirma tres
`login/failed` de `192.0.2.25` para
`maria`, a las 01:35, 01:36 y 01:37 (UTC−05:00). Aunque ocurren dentro de una
misma ventana de cinco minutos, son solo tres eventos: la regla exige al menos
seis fallos exactos para la misma combinación de IP y usuario. Por eso no
alcanzan el umbral y no justifican una alerta de fuerza bruta.

La fila 42 muestra un `login/success` un minuto después, a las 01:38; su detalle
lo describe como usuario legítimo. Ese éxito es contexto registrado, no prueba
independiente de la identidad ni convierte retroactivamente los tres fallos en
fuerza bruta. Tampoco hay evidencia en esas filas de password spraying: los
tres fallos son contra un solo usuario. No se excluyeron eventos mediante
suposiciones adicionales.

## Actividad normal y límites

- Los eventos `healthcheck/success` de las filas 78, 80–84 no son
  `login/failed` y no cuentan para los umbrales de autenticación.
- Las filas citadas para el password spraying y el token coinciden con sus
  reglas; las coincidencias repetidas en la alerta de fuerza bruta se reportan
  con la incertidumbre indicada, sin deduplicarlas mediante una regla no
  especificada.
- Las IP son datos del CSV de clase; no se consultaron ni se trataron como
  infraestructura real.
