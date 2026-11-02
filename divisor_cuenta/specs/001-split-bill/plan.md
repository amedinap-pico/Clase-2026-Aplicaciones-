# Plan de implementación: División de cuenta

**Rama**: `001-split-bill`  
**Especificación**: [spec.md](spec.md)

## Resumen

Implementar una pantalla para ingresar el monto de una cuenta, el número de personas y el porcentaje de propina. La persona elige entre redondeo exacto y redondeo hacia arriba, y pulsa **Calcular** para ver cuánto paga cada persona. La validación y las reglas de cálculo viven en `domain`, sin importar Flutter. No se agregan dependencias ni persistencia.

## Arquitectura y responsabilidades

- `domain/cuenta.dart`: datos de entrada del cálculo.
- `domain/resultado.dart`: resultado del cálculo.
- `domain/estrategia_redondeo.dart`: contrato para las estrategias de redondeo.
- `domain/validar_entrada.dart`: validación de los valores ingresados.
- `domain/calcular_division.dart`: calcula el total con propina, lo divide entre las personas y usa la estrategia recibida.
- `data/redondeo_exacto.dart` y `data/redondeo_hacia_arriba.dart`: implementaciones del contrato de redondeo.
- `presentation/divisor_controller.dart`: coordina validación y cálculo.
- `presentation/formateador_moneda.dart` y `presentation/pantalla_divisor.dart`: formato y presentación de la pantalla.
- `main.dart`: compone las implementaciones concretas.

La dirección de dependencias es `presentation -> domain <- data`. `domain` no importa Flutter. El cálculo depende del contrato de redondeo y no comprueba el tipo concreto de la estrategia.

## Decisiones de comportamiento

- El porcentaje de propina lo ingresa el usuario y puede ser cero.
- El monto y la propina deben ser numéricos, finitos y no negativos. Debe haber al menos una persona.
- Se calcula primero el total con propina; después se divide entre las personas y se aplica la estrategia seleccionada.
- El modo exacto redondea el pago a dos decimales. El modo hacia arriba redondea al entero monetario siguiente.
- `Resultado` contiene una sola cuota por persona y no una lista de asignaciones. No se redistribuyen residuos: al redondear hacia arriba, la suma cobrada puede superar el total de la cuenta (por ejemplo, 10.00 entre 3 personas produce 4.00 por persona, 12.00 en total).
- La pantalla calcula al pulsar **Calcular** y no presenta un resultado si los datos son inválidos.
- El resultado visible usa dos decimales.

## Verificación

La especificación define seis escenarios de aceptación. Las pruebas existentes incluyen casos de dominio, sustitución de estrategias y estados de la pantalla. También se revisan las dependencias entre capas y que no se agreguen paquetes ni se modifiquen las plataformas.
