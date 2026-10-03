# Análisis de la especificación — Divisor de cuenta

## Propósito y criterio de clasificación

Este análisis toma como fuente la especificación Flutter
[`divisor_cuenta/specs/001-split-bill/spec.md`](../divisor_cuenta/specs/001-split-bill/spec.md)
y la compara con la especificación web
[`specs/001-dividir-cuenta/requirements.md`](specs/001-dividir-cuenta/requirements.md).

- **QUÉ:** necesidad, comportamiento observable, reglas y restricciones del
  producto, expresados sin comprometer una tecnología o estructura interna.
- **CÓMO:** decisión de diseño, arquitectura, tecnología, organización del
  código o mecanismo de verificación.
- **MIXTO:** enunciado que combina el resultado que se requiere con una manera
  concreta de implementarlo.

La unidad de conteo es cada enunciado atómico de la tabla. Se clasifican 23
enunciados explícitos de la especificación original; contar por ideas atómicas
evita ocultar decisiones mixtas dentro de párrafos largos.

## Clasificación de enunciados de la spec

| # | Enunciado resumido | Clasificación | Justificación |
|---:|---|---|---|
| 1 | Una persona necesita conocer la cuota individual de una cuenta con propina. | QUÉ | Expresa valor para quien usa el producto. |
| 2 | 100.00, 4 personas, 10%, exacto → 27.50. | QUÉ | Resultado observable de aceptación. |
| 3 | 90.00, 3 personas, 0%, exacto → 30.00. | QUÉ | Resultado observable de aceptación. |
| 4 | Cero personas debe informar el error y no mostrar resultado. | QUÉ | Regla de validación visible. |
| 5 | Monto no numérico debe informar “Monto inválido”. | QUÉ | Regla de validación visible. |
| 6 | 10.00, 3 personas, 0%, exacto → 3.33. | QUÉ | Resultado observable de aceptación. |
| 7 | Los mismos datos hacia arriba → 4.00. | QUÉ | Resultado observable de aceptación. |
| 8 | Monto, personas, propina, selector y botón están en una sola pantalla. | MIXTO | El conjunto de controles es de interfaz (CÓMO); las entradas y la acción solicitadas expresan la capacidad (QUÉ). |
| 9 | Exacto redondea la cuota al centavo más cercano. | QUÉ | Define la política monetaria visible, no su implementación. |
| 10 | Hacia arriba redondea la cuota al entero monetario siguiente. | QUÉ | Define otra política visible. |
| 11 | La cuota es igual por persona y no se redistribuyen residuos. | QUÉ | Define qué significa el resultado para cada persona. |
| 12 | Monto y propina son números finitos no negativos; personas es entero positivo. | QUÉ | Reglas de validez del producto. |
| 13 | Una entrada inválida muestra error y suprime el resultado. | QUÉ | Comportamiento observable frente a errores. |
| 14 | El resultado visible tiene dos decimales. | QUÉ | Formato observable, independiente de biblioteca. |
| 15 | No guardar datos ni requerir conexión. | QUÉ | Restricciones de producto y privacidad. |
| 16 | Separar `domain`, `data` y `presentation`. | CÓMO | Asigna responsabilidades a capas. |
| 17 | Mantener el dominio sin importar Flutter. | CÓMO | Restricción de dependencias de la arquitectura original. |
| 18 | Implementar redondeos concretos como estrategias de datos. | CÓMO | Especifica dónde y mediante qué patrón organizar algoritmos. |
| 19 | Componer estrategias desde el punto de entrada y orientar dependencias al dominio. | CÓMO | Describe ensamblaje e inversión de dependencias. |
| 20 | La propina la ingresa la persona y puede ser cero. | QUÉ | Regla de entrada y rango permitido. |
| 21 | Primero sumar propina, después dividir y finalmente redondear. | MIXTO | El orden produce una regla de negocio observable, pero también prescribe el algoritmo. |
| 22 | Calcular al tocar el botón; usar los seis escenarios como fuente de pruebas. | MIXTO | La acción es comportamiento (QUÉ); vincular casos a una suite es proceso de verificación (CÓMO). |
| 23 | La aplicación funciona sin conexión. | QUÉ | Atributo requerido del producto, no una elección de implementación específica. |

## Porcentajes del análisis

Con el conteo atómico anterior:

- QUÉ: `16 / 23 × 100 = 69.57%`
- CÓMO: `4 / 23 × 100 = 17.39%`
- MIXTO: `3 / 23 × 100 = 13.04%`

Comprobación: `69.57% + 17.39% + 13.04% = 100.00%` (la suma sin redondear es
100%). Estos porcentajes describen **la distribución de los enunciados
clasificados**, no la nota del deber, el porcentaje de código ni la cobertura de
pruebas. Se pueden reproducir contando las filas de la tabla.

## Análisis de la Constitution y adaptación a React/Vite

La Constitución fuente está en
[`divisor_cuenta/.specify/memory/constitution.md`](../divisor_cuenta/.specify/memory/constitution.md).
Su intención se conserva, pero las referencias de Flutter/Dart se traducen a
React/JavaScript. Esta es una adaptación analítica para el proyecto web; no se
afirma que exista una nueva Constitution formalmente ratificada.

| Principio/restricción fuente | Adaptación web | Evidencia del proyecto | Evaluación |
|---|---|---|---|
| SRP: interfaz, entidades y reglas no mezcladas. | Componentes/hook en `presentation`, entidades y casos de uso en `domain`, estrategias en `data`. | `PantallaDivisor.jsx`, `useDivisor.js`, `Cuenta`, `ValidarEntrada`, `CalcularDivision`. | Separación visible por responsabilidad. |
| OCP: extender políticas mediante estrategia. | El caso de uso usa el método `redondear`; el punto de entrada selecciona la implementación. | `CalcularDivision.calcular(cuenta, estrategia)` y composición de estrategias en `main.jsx`. | Admite una política nueva sin cambiar el cálculo, si cumple el contrato. |
| LSP: implementaciones sustituibles con resultado válido. | `RedondeoExacto` y `RedondeoHaciaArriba` reciben una cuota y devuelven `Resultado`. | `src/data/` y prueba “el cálculo acepta estrategias intercambiables”. | La prueba demuestra sustitución funcional; no constituye prueba formal de todas las propiedades posibles del contrato. |
| ISP: contratos pequeños. | La estrategia requiere solo `redondear(monto)`. | `src/domain/estrategiaRedondeo.js`. | Contrato acotado al consumidor. |
| DIP: las dependencias apuntan al dominio. | Presentación consume servicios/modelos de dominio; las estrategias de datos implementan el contrato del dominio; `main.jsx` compone detalles. | Imports de `src/domain/`, `src/data/` y `src/main.jsx`. | El dominio no importa React ni presentación; el ensamblaje concreto está en el borde. |
| Null safety de Dart. | JavaScript no ofrece la misma garantía estática; validar `Number.isFinite`, enteros y estrategia en tiempo de ejecución. | `ValidarEntrada` y guardas de `CalcularDivision`. | Adaptación funcional, no equivalencia de sistema de tipos. |
| No agregar dependencias externas sin autorización. | Dependencias de producto permanecen React/Vite; Vitest/Testing Library/jsdom son herramientas de desarrollo para pruebas de interfaz. | `package.json`. | Se incorporó tooling de pruebas para cumplir la verificación automatizada solicitada; no se agrega servicio de ejecución al producto. |
| No crear datos remotos sin fuente. | `data` contiene políticas de redondeo locales; no hay API, almacenamiento ni persistencia. | `src/data/`; no se hallan usos de almacenamiento ni `fetch` en `src/`. | Acorde al alcance. |
| La cuota no debe prometer conservar el total. | Redondeo es por cuota; no se calculan pagos residuales. | Requerimiento RF-10 y escenario 6. | Para 10.00 entre 3, 4.00 × 3 = 12.00; el exceso se documenta como conducta intencional. |
| Verificar aceptación y capas. | `npm test`, `npm run lint`, `npm run build`; pruebas de dominio y de presentación. | `test/domain.test.js`, `test/pantalla.test.jsx`, scripts de `package.json`. | La suite automatizada cubre ejemplos y validaciones; no reemplaza revisión visual en todos los navegadores/dispositivos. |

### Cálculos de porcentaje y redondeo de aceptación

La propina porcentual se aplica sobre el monto antes de dividir:

`total = monto × (1 + propina / 100)`  
`cuota = total / personas`

1. **Caso 1:** propina `100 × 10 / 100 = 10.00`; total `110.00`; cuota
   `110.00 / 4 = 27.50`; exacto → `27.50`.
2. **Caso 2:** propina `90 × 0 / 100 = 0.00`; total `90.00`; cuota
   `90.00 / 3 = 30.00`; exacto → `30.00`.
3. **Caso 3:** la división por cero personas no se realiza. La validación
   retorna `Debe haber al menos una persona`.
4. **Caso 4:** el texto no se convierte a un número finito; la validación
   retorna `Monto inválido`.
5. **Caso 5:** total `10.00`; cuota exacta `10 / 3 = 3.333…`; a centavos da
   `3.33`.
6. **Caso 6:** la misma cuota `3.333…` con `ceil` da `4.00`; cobro agregado
   `4.00 × 3 = 12.00`. Frente al total de `10.00`, la diferencia es `2.00`,
   equivalente a `2 / 10 × 100 = 20%` del monto base. No se ajusta el último
   pago porque el requisito define una cuota uniforme, no una distribución.

La diferencia entre `3.33` y `4.00` no es un error: son políticas de
redondeo diferentes aplicadas al pago individual, como especifica RF-05, RF-06
y RF-10.
