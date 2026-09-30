# Feature Specification: División de cuenta

**Rama de función:** `001-split-bill`  
**Estado:** Implementada para la práctica de Semana 7

## Objetivo

Una pantalla permite ingresar el monto, el número de personas y el porcentaje de propina. Al tocar **Calcular**, presenta el pago individual según el modo de redondeo elegido. La aplicación funciona sin conexión.

## Escenarios de aceptación

1. Monto 100.00, 4 personas, 10% de propina y modo exacto produce 27.50 por persona.
2. Monto 90.00, 3 personas, 0% de propina y modo exacto produce 30.00 por persona.
3. Monto 50.00 y 0 personas muestra `Debe haber al menos una persona` y no presenta resultado.
4. Un monto no numérico muestra `Monto inválido`.
5. Monto 10.00, 3 personas, 0% de propina y modo exacto produce 3.33 por persona.
6. Los mismos valores en modo hacia arriba producen 4.00 por persona.

## Requisitos funcionales

- Una sola pantalla tiene campos para monto, personas y porcentaje de propina, selector de redondeo y botón Calcular.
- El modo exacto redondea el pago individual al centavo más cercano.
- El modo hacia arriba redondea el pago individual al entero monetario siguiente.
- Monto y propina deben ser numéricos, finitos y no negativos; personas debe ser entero positivo.
- Ante datos inválidos se muestra un mensaje y no se presenta ningún resultado.
- El formato visible del resultado usa dos decimales.
- No se guarda información ni se requiere conexión.

## Arquitectura

- `domain`: Cuenta, Resultado, EstrategiaRedondeo, CalcularDivision y ValidarEntrada; Dart puro.
- `data`: implementaciones RedondeoExacto y RedondeoHaciaArriba.
- `presentation`: DivisorController, FormateadorMoneda y PantallaDivisor.
- `main.dart` compone las implementaciones concretas; dependencias: presentation -> domain <- data.

## Supuestos y decisiones

- El porcentaje de propina es ingresado por el usuario y puede ser cero.
- Primero se calcula el total con propina; luego se divide entre las personas y se aplica la estrategia elegida.
- La pantalla calcula solo cuando se toca el botón. Los seis escenarios de esta spec son la fuente de las pruebas.
