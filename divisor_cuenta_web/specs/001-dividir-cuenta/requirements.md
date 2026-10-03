# Requerimientos: Dividir cuenta

**Origen:** [especificación Flutter](../../divisor_cuenta/specs/001-split-bill/spec.md)
y su implementación.  
**Estado:** Borrador inicial para la versión web del Deber 2.

## Objetivo

Permitir que una persona calcule cuánto le corresponde pagar a cada integrante
al dividir una cuenta, incluyendo propina y el modo de redondeo que elija.

## Alcance

- Una pantalla para ingresar los datos de la cuenta, elegir el redondeo y
  consultar el resultado.
- Cálculo local, sin conexión, cuentas de usuario ni persistencia.
- El resultado es una cuota igual por persona; no se asignan residuos ni se
  garantiza que la suma de las cuotas reproduzca el total exacto.

## Requerimientos funcionales

- **RF-01 — Datos de entrada:** La pantalla permite ingresar el monto de la
  cuenta, el número de personas y el porcentaje de propina. La propina puede
  ser cero. Al abrir la pantalla, el valor inicial de propina es 10%.
- **RF-02 — Modo de redondeo:** La persona puede elegir entre modo exacto y
  modo hacia arriba. El modo exacto es el modo inicial.
- **RF-03 — Acción de cálculo:** El cálculo se ejecuta cuando la persona activa
  **Calcular**, no automáticamente mientras edita los campos.
- **RF-04 — Cálculo de la cuota:** Primero se suma la propina porcentual al
  monto; el total resultante se divide entre el número de personas; al final
  se aplica el modo elegido.
- **RF-05 — Modo exacto:** Redondea la cuota individual al centavo más cercano.
- **RF-06 — Modo hacia arriba:** Redondea la cuota individual al siguiente
  entero monetario; si ya es entero, permanece igual.
- **RF-07 — Validación:** El monto y la propina deben ser valores numéricos,
  finitos y no negativos. El número de personas debe ser un entero mayor o
  igual a uno.
- **RF-08 — Errores:** Si hay una entrada inválida, se muestra un mensaje
  identificable para el campo y no se muestra un resultado de cálculo:
  - monto inválido: `Monto inválido`
  - cantidad de personas menor que uno: `Debe haber al menos una persona`
  - propina inválida: `Propina inválida`
- **RF-09 — Resultado:** Cuando las entradas son válidas, se muestra el pago
  por persona con exactamente dos decimales.
- **RF-10 — Cuota, no distribución:** Cada persona paga la misma cuota
  redondeada. No se redistribuyen centavos ni se ajusta el último pago para
  conservar el total. Por ejemplo, 10.00 entre 3 personas en modo hacia arriba
  produce 4.00 por persona (12.00 en conjunto).

## Requerimientos de calidad y límites

- **RC-01:** La funcionalidad debe operar sin conexión a Internet.
- **RC-02:** Los datos ingresados no se guardan después de usar la pantalla.
- **RC-03:** La interfaz debe poder usarse en tamaños de pantalla de escritorio
  y móvil, sin perder campos, selector, acción, error o resultado.
- **RC-04:** El comportamiento visible y los mensajes deben estar en español.
- **L-01:** No se agregan funciones ajenas al divisor de cuenta, como dividir
  importes distintos por persona, guardar historial o iniciar sesión.
- **L-02:** No se agregan dependencias de terceros salvo que el alcance lo
  requiera y se apruebe.

## Escenarios de aceptación

1. Con monto 100.00, 4 personas, propina 10% y modo exacto, al calcular se
   muestra `27.50` por persona.
2. Con monto 90.00, 3 personas, propina 0% y modo exacto, al calcular se
   muestra `30.00` por persona.
3. Con monto 50.00, 0 personas y propina 0%, al calcular se muestra
   `Debe haber al menos una persona` y no aparece un resultado.
4. Con monto no numérico y las demás entradas válidas, al calcular se muestra
   `Monto inválido`.
5. Con monto 10.00, 3 personas, propina 0% y modo exacto, al calcular se
   muestra `3.33` por persona.
6. Con los mismos datos del escenario 5 y modo hacia arriba, al calcular se
   muestra `4.00` por persona.

## Trazabilidad

| Requerimientos | Escenarios de aceptación |
|---|---|
| RF-01, RF-02, RF-03, RF-04, RF-05, RF-09 | 1, 2, 5 |
| RF-06, RF-10 | 6 |
| RF-07, RF-08 | 3, 4 |
| RC-01, RC-02, RC-03, RC-04, L-01, L-02 | Aplican a toda la experiencia |

## Fuentes y decisiones

- La especificación Flutter es la fuente del comportamiento y de los seis
  escenarios; esta versión no cambia sus reglas de cálculo.
- La implementación Flutter inicializa la propina en 10% y selecciona modo
  exacto. Se documentan aquí para evitar que la migración web cambie el estado
  inicial.
- Las decisiones de arquitectura web se describen por separado en
  [analysis.md](analysis.md); no son requisitos de comportamiento.
