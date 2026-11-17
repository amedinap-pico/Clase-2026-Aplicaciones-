# Reglas de detección

Estas reglas se aplican a logs CSV con los campos `timestamp`, `ip`, `user`,
`event`, `result` y `detail`. Ordena por `timestamp` antes de revisar ventanas.
Una ventana de 5 minutos incluye ambos extremos (`≤ 5 minutos`). Cita las filas
del archivo original; cuenta el encabezado como fila 1. Los valores de `event`
y `result` deben coincidir exactamente con los indicados.

## Fuerza bruta probable

- Agrupa eventos de la misma `ip` y el mismo `user`.
- Alerta si hay 6 o más eventos con `event=login` y `result=failed` dentro de
  una ventana de 5 minutos.
- Si aparece un evento `event=login` y `result=success` en los 5 minutos
  siguientes, anótalo como contexto separado con su fila y timestamp. No lo
  presentes como prueba de que los fallos causaron el éxito.

## Password spraying probable

- Agrupa por `ip`.
- Alerta si la misma IP tiene eventos `event=login` y `result=failed` contra
  al menos 5 usuarios distintos dentro de una ventana de 5 minutos.
- Cita las filas de los eventos contados y señala los usuarios distintos que
  sustentan el umbral.

## Token potencialmente expuesto

- Un campo `detail` que contenga literalmente `token=` genera una alerta de
  posible exposición.
- No imprimas el valor del token, ni parcialmente. Sustitúyelo por
  `[REDACTED]` en informes, ejemplos y evidencia citada.

## Escalada no autorizada según el registro

- Alerta ante `event=role_change`, `result=success` y `detail` que indique
  `approved=false`.
- Describe únicamente lo registrado. No infieras quién actuó, su intención ni
  culpabilidad.

## Falsos positivos y límites

- Tres fallos aislados no alcanzan el umbral de fuerza bruta.
- Un evento `healthcheck` no cuenta como `event=login` y `result=failed`.
- No cuentes tipos de evento/resultados que no coincidan exactamente.
- Si hay duplicados cuya identidad no se puede determinar inequívocamente,
  declara la limitación; no inventes una regla para excluirlos.

Las reglas sustentan alertas para revisión, no conclusiones forenses ni
confirmación de intrusión.
