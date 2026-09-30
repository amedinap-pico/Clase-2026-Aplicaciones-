# Feature Specification: División de cuenta

**Feature Branch**: `001-split-bill`

**Created**: 2026-09-30

**Status**: Draft

**Input**: User description: "Aplicación Flutter de una sola pantalla para dividir una cuenta: ingresar el monto total, el número de personas y una propina de 10%, 15% o 20%; calcular automáticamente el total con propina y lo que paga cada persona. Respetar la arquitectura limpia descrita en AGENTS.md."

## User Scenarios & Testing

### User Story 1 - Dividir la cuenta (Priority: P1)

Como persona que paga una cuenta compartida, quiero ingresar el monto y cuántas personas participan para saber cuánto corresponde a cada una.

**Why this priority**: Es el propósito principal de la aplicación y entrega valor incluso antes de ajustar la propina.

**Independent Test**: Ingresar un monto válido y una cantidad de personas, y comprobar que el total y el reparto aparecen en la misma pantalla.

**Acceptance Scenarios**:

1. **Given** una cuenta de 120 unidades monetarias, 3 personas y una propina seleccionada del 10%, **When** se ingresan esos valores, **Then** la pantalla muestra un total de 132 y un reparto de 44 por persona.
2. **Given** un monto y una propina ya ingresados, **When** cambia el número de personas, **Then** el importe por persona se actualiza automáticamente sin requerir una acción adicional.

### User Story 2 - Elegir la propina (Priority: P2)

Como persona que organiza el pago, quiero elegir una propina del 10%, 15% o 20% para ver cómo cambia el total y el reparto.

**Why this priority**: La propina forma parte del cálculo solicitado y debe poder ajustarse de forma directa.

**Independent Test**: Con una cuenta de 200 unidades monetarias y 4 personas, probar cada porcentaje y verificar el total y el valor individual resultantes.

**Acceptance Scenarios**:

1. **Given** una cuenta de 200 unidades monetarias y 4 personas, **When** se selecciona 10%, **Then** el total es 220 y cada persona paga 55.
2. **Given** una cuenta de 200 unidades monetarias y 4 personas, **When** se selecciona 15%, **Then** el total es 230 y cada persona paga 57,50.
3. **Given** una cuenta de 200 unidades monetarias y 4 personas, **When** se selecciona 20%, **Then** el total es 240 y cada persona paga 60.

### User Story 3 - Obtener un reparto válido (Priority: P3)

Como persona que comparte el pago, quiero que el reparto siga siendo correcto ante valores incompletos o divisiones con fracciones de centavo, para evitar resultados engañosos.

**Why this priority**: La validación y el redondeo preservan la confianza en el importe que debe pagar cada persona.

**Independent Test**: Probar un monto vacío, una cantidad mínima de personas y un total que no pueda dividirse en partes iguales hasta el centavo.

**Acceptance Scenarios**:

1. **Given** que el monto está vacío o no es válido, **When** se muestra el resultado, **Then** la aplicación no presenta un reparto como si el dato fuera una cuenta válida y permite corregir el monto.
2. **Given** un total con propina de 11 unidades monetarias y 3 personas, **When** se calcula el reparto, **Then** dos pagos son de 3,67 y uno de 3,66, y la suma coincide con el total.
3. **Given** que se introduce una cantidad de personas menor que 1 o no entera, **When** se valida el dato, **Then** no se acepta para calcular el reparto y se informa que se requiere una cantidad entera positiva.

### Edge Cases

- El monto es cero, está vacío, contiene texto no numérico o es negativo.
- El número de personas es cero, negativo, fraccionario o se borra durante la edición.
- La propina hace que el total incluya fracciones de centavo.
- El total final no se divide exactamente entre las personas.
- El usuario cambia varios valores consecutivamente; el resultado debe corresponder siempre a los valores vigentes.

## Requirements

### Functional Requirements

- **FR-001**: La aplicación MUST ofrecer una pantalla única para ingresar y consultar el reparto de una cuenta.
- **FR-002**: La pantalla MUST permitir ingresar el monto total de la cuenta y una cantidad entera positiva de personas.
- **FR-003**: La pantalla MUST permitir seleccionar exclusivamente una propina del 10%, 15% o 20%, con 10% seleccionado inicialmente.
- **FR-004**: La aplicación MUST calcular automáticamente el valor de la propina y el total con propina cada vez que cambie un dato válido.
- **FR-005**: La aplicación MUST mostrar el total con propina y el importe que corresponde pagar a cada persona.
- **FR-006**: La aplicación MUST calcular un reparto igualitario; si el total no se puede dividir exactamente en centavos, MUST distribuir el remanente de manera que la suma de los pagos individuales sea igual al total y los pagos difieran como máximo en un centavo.
- **FR-007**: La aplicación MUST validar que el monto sea numérico y no negativo, y que la cantidad de personas sea un entero positivo. Ante un dato inválido, MUST indicar qué corregir y no presentar un reparto válido basado en ese dato.
- **FR-008**: La interfaz MUST actualizar el resultado sin requerir que la persona confirme o navegue a otra pantalla.

### Architecture Constraints

- El código de la aplicación MUST organizarse en `lib/presentation`, `lib/domain` y `lib/data`.
- La dirección de dependencias MUST ser `presentation -> domain <- data`; presentación y datos pueden depender del dominio, pero el dominio no depende de esas capas.
- `domain` MUST permanecer independiente de Flutter y no importar `package:flutter`.

### Key Entities

- **Cuenta**: Representa el monto base ingresado y el porcentaje de propina seleccionado.
- **Reparto**: Representa la cantidad de personas, el importe de propina, el total final y los importes individuales resultantes.

## Success Criteria

### Measurable Outcomes

- **SC-001**: Para una cuenta de 120 unidades monetarias, 3 personas y 10% de propina, el usuario ve un total de 132 y un pago individual de 44.
- **SC-002**: Al cambiar un dato válido, el total y el importe individual visibles se actualizan en menos de 1 segundo, sin confirmación adicional.
- **SC-003**: Las opciones de 10%, 15% y 20% producen resultados correctos en todos los casos de aceptación correspondientes.
- **SC-004**: En los casos de división con fracciones de centavo, la suma de los importes individuales coincide exactamente con el total con propina.
- **SC-005**: El usuario puede completar el cálculo principal desde la pantalla única, sin navegar a otra vista.

## Assumptions

- La cuenta se divide en partes iguales; no se asignan consumos o importes distintos a personas individuales.
- El 10% es la selección inicial de propina.
- Los importes se expresan en una unidad monetaria elegida por el usuario; esta especificación no fija una moneda o símbolo.
- La precisión monetaria es de dos decimales y los importes se redondean al centavo más cercano. Si hay centavos sobrantes, se distribuyen entre algunos pagos individuales para conservar el total; la diferencia entre pagos no supera un centavo.
- El cálculo corresponde a una cuenta activa en pantalla; guardar o recuperar cuentas no forma parte de este alcance.