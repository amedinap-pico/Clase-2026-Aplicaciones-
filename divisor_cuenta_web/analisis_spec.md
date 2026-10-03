# Análisis de la especificación — Deber 2

## Fuentes y método

- Especificación de Flutter:
  [`divisor_cuenta/specs/001-split-bill/spec.md`](../divisor_cuenta/specs/001-split-bill/spec.md).
- Copia de trabajo React:
  [`specs/001-dividir-cuenta/spec.md`](specs/001-dividir-cuenta/spec.md).
- Constitución Flutter:
  [`divisor_cuenta/.specify/memory/constitution.md`](../divisor_cuenta/.specify/memory/constitution.md).
- Constitución React:
  [`.specify/memory/constitution.md`](.specify/memory/constitution.md).

Se cuentan enunciados semánticos atómicos: las repeticiones de la misma regla
en distintas secciones se agrupan en una sola fila, pero se separan las reglas
independientes que comparten una viñeta. La tabla contiene 28 enunciados. La
clasificación QUÉ/CÓMO/MIXTO responde si cada idea sigue siendo válida en React;
el estado de viaje distingue conservación literal de adaptación tecnológica.

La copia `specs/001-dividir-cuenta/spec.md` se creó en esta revisión mediante
copia directa de la fuente. Los SHA-256 comprobados fueron iguales:

```text
Flutter: 011DF4F82AA270D6469C3B84F44F992E9048439C998CA284FA3A06452DAE7897
React:   011DF4F82AA270D6469C3B84F44F992E9048439C998CA284FA3A06452DAE7897
```

Esto prueba que las dos copias son idénticas **ahora**. No demuestra que el diff
inicial se hubiese guardado antes de iniciar el trabajo React; ese dato
histórico no se registró.

## Spec: clasificación y viaje a React

| # | Enunciado atómico de la spec | Tipo | ¿Viaja? | Justificación |
|---:|---|---|---|---|
| 1 | La persona ingresa monto, personas y porcentaje de propina. | QUÉ | Intacto | Entradas de negocio; no dependen de plataforma. |
| 2 | Al activar Calcular se muestra la cuota según el modo elegido. | QUÉ | Intacto | Acción y resultado observables. |
| 3 | La app funciona sin conexión. | QUÉ | Intacto | Restricción de producto. |
| 4 | 100, 4 personas, 10%, exacto → 27.50. | QUÉ | Intacto | Criterio numérico de aceptación. |
| 5 | 90, 3 personas, 0%, exacto → 30.00. | QUÉ | Intacto | Criterio numérico de aceptación. |
| 6 | 50, 0 personas → error de personas y sin resultado. | QUÉ | Intacto | Regla y salida observables. |
| 7 | Monto no numérico → “Monto inválido”. | QUÉ | Intacto | Mensaje verificable. |
| 8 | 10, 3 personas, 0%, exacto → 3.33. | QUÉ | Intacto | Criterio numérico de aceptación. |
| 9 | Los mismos valores hacia arriba → 4.00. | QUÉ | Intacto | Criterio numérico de aceptación. |
| 10 | Una sola pantalla contiene los campos, selector y botón. | QUÉ | Intacto | La misma pantalla es válida en React; no se especifica un widget Flutter. |
| 11 | Exacto redondea la cuota al centavo más cercano. | QUÉ | Intacto | Política de negocio independiente del runner. |
| 12 | Hacia arriba redondea al entero monetario siguiente. | QUÉ | Intacto | Política de negocio independiente del runner. |
| 13 | El resultado es una cuota igual, no un arreglo de pagos residuales. | QUÉ | Intacto | Semántica observable del cobro. |
| 14 | La suma de cuotas puede diferir del total por la política de redondeo. | QUÉ | Intacto | Consecuencia explícita del contrato. |
| 15 | 10 entre 3 hacia arriba muestra 4 por persona, 12 en total, sin redistribuir. | QUÉ | Intacto | Ejemplo y límite explícitos. |
| 16 | El monto es numérico, finito y no negativo. | QUÉ | Intacto | Validación de dominio. |
| 17 | La propina es numérica, finita y no negativa. | QUÉ | Intacto | Validación de dominio. |
| 18 | Personas es entero positivo. | QUÉ | Intacto | Validación de dominio. |
| 19 | Ante datos inválidos se muestra mensaje y no resultado. | QUÉ | Intacto | Comportamiento de error. |
| 20 | El resultado visible usa dos decimales. | QUÉ | Intacto | Formato observable. |
| 21 | No se guarda información. | QUÉ | Intacto | Restricción de privacidad/alcance. |
| 22 | `domain` reúne entidades, contrato, cálculo y validación; debe ser Dart puro. | MIXTO | Adaptado | Las responsabilidades viajan; Dart se reemplaza por JavaScript sin React/DOM. |
| 23 | `data` aloja las implementaciones concretas de redondeo. | CÓMO | Adaptado | El patrón/capa se conserva; sintaxis e implementación pasan de Dart a JS. |
| 24 | `presentation` coordina, formatea y dibuja la pantalla. | CÓMO | Adaptado | La responsabilidad se conserva; controller/widgets se traducen a hook/componentes. |
| 25 | `main.dart` compone implementaciones y fija `presentation -> domain <- data`. | CÓMO | Adaptado | Se conserva la dirección; el punto de entrada web es `main.jsx`. |
| 26 | La persona ingresa la propina y puede ingresar cero. | QUÉ | Intacto | Regla de entrada. |
| 27 | Se agrega la propina, se divide y después se aplica redondeo. | QUÉ | Intacto | Regla de negocio; la traducción de sintaxis no altera su orden. |
| 28 | Los seis escenarios de aceptación son fuente de las pruebas. | MIXTO | Adaptado | Los casos/resultados viajan; el archivo y runner Flutter se traducen a pruebas JS. |

### Porcentajes de viaje

Según la tabla y su denominador de 28 enunciados:

- **Viajó intacto:** `23 / 28 × 100 = 82.14%`.
- **Viajó con adaptación:** `5 / 28 × 100 = 17.86%`.
- **No pudo reutilizarse:** `0 / 28 × 100 = 0%`.

El 100% de las filas conserva utilidad semántica; cinco enunciados de diseño o
prueba necesitan vocabulario/artefactos web. La métrica no afirma que se haya
reutilizado código Dart. El porcentaje depende de la atomización declarada:
las ideas duplicadas se agruparon para que no pesen doble.

### Porcentaje CÓMO de la spec y umbral de la materia

En la clasificación de tipo hay 3 CÓMO de 28:

`% CÓMO = 3 / 28 × 100 = 10.71%`.

Las 2 filas MIXTAS se reportan aparte y no se cuentan como CÓMO, de acuerdo con
la consigna. El 30% es el **umbral pedagógico de este deber**, no una regla
universal de SDD. Con este conteo no se supera el umbral. Las decisiones
tecnológicas explícitas identificadas son las capas y la arquitectura Dart; no
se encontró una librería de estado Flutter prescrita por la spec.

## Constitution: comparación regla por regla

Estados: **idéntica** (mismo principio sin cambio semántico), **adaptada en
redacción** (misma intención, vocabulario tecnológico distinto),
**reemplazada** (la restricción anterior no aplica al proyecto nuevo), o
**nueva** (requerida por la guía web sin equivalente explícito en la fuente).

| Regla Flutter | Estado | Regla/adaptación React y evidencia |
|---|---|---|
| SRP: UI, entidades y servicio no mezclan responsabilidades monetarias. | Adaptada en redacción | Módulos React/domain separan interfaz, datos y reglas; `calcularDivision.js` calcula. |
| OCP: políticas nuevas mediante estrategia sin cambiar política existente. | Idéntica | `CalcularDivision` recibe estrategia; implementaciones están en `src/data/`. |
| LSP: estrategia válida devuelve resultado finito, no negativo y acorde a su política; no promete conservar suma. | Idéntica | Ambas estrategias satisfacen el contrato `aplicar`; hay prueba de sustitución y criterios de cuota. |
| ISP: contratos solo exponen operaciones consumidas. | Idéntica | Contrato mínimo `aplicar(valor)`. |
| DIP: presentación al dominio; dominio sin Flutter/UI/data. | Adaptada en redacción | Constitution React prohíbe React/DOM en domain y prescribe `presentation -> domain <- data`. |
| Flutter y Dart con null safety. | Reemplazada | React/Vite y JavaScript son el runtime objetivo; la guía requiere Node y no existe null safety Dart en JS. Validación se realiza en runtime. |
| Clases, variables y métodos en español. | Idéntica | UI, modelos, métodos y errores del proyecto permanecen en español; nombres de APIs/framework se conservan. |
| No incorporar dependencias externas sin autorización. | Idéntica con excepción documentada | No hay dependencias de producto nuevas; las devDependencies Vitest, jsdom y Testing Library se añadieron para cumplir las pruebas web expresamente pedidas. |
| Capas en `lib/...`; no crear infraestructura sin una fuente externa. | Adaptada en redacción | Se usan `src/...`; `data` contiene estrategias locales, sin API/base remota. |
| Resultado es cuota uniforme, residuos no se redistribuyen. | Idéntica | RF-10 y caso 10/3 → 4.00 × 3 = 12.00. |
| No modificar `test/`, `android/`, `ios/` salvo solicitud. | Reemplazada | Esas plataformas pertenecen a Flutter y no forman parte de este web project; las pruebas React sí se crean porque el deber lo exige. |
| Correr `flutter analyze` y `flutter test`. | Adaptada en redacción | `npm run lint`, `npm test`, `npm run build`; pruebas nativas y de UI web. |
| Gobierno: si se contradice un principio, explicar la excepción en plan. | Idéntica | Esta tabla y el plan documentan adaptaciones/excepciones; la Constitution no se declara ratificada por Spec Kit. |
| “Nunca guardar secretos/API keys en Git”. | Nueva | Regla de seguridad explícitamente solicitada en la Constitution React del enunciado; la fuente Flutter no contiene regla equivalente. |
| Toda función crítica debe tener pruebas; acceptance se vuelve ejecutable. | Nueva | Regla de calidad/pruebas requerida por la consigna web; la fuente Flutter solo exige las suites concretas en su flujo. |
| El estudiante puede explicar toda función generada. | Nueva | Regla pedagógica explícita de la consigna web, sin equivalente literal en la Constitution Flutter. |
| Capas `src/...`, domain JS puro y composición concreta en `main.jsx`. | Adaptada en redacción | Equivalentes web explícitos de capas/lib, Dart puro y composición `main.dart` del proyecto original. |

Las tres reglas marcadas **nueva** no se atribuyen a la Constitución Flutter:
se agregan porque el profesor las exige para la versión web. El archivo
[`constitution.md`](.specify/memory/constitution.md) transcribe esos principios
adaptados; no hay evidencia de haber ejecutado `/speckit-constitution`.

## Cálculos de los criterios

Fórmula:

`total = monto × (1 + propina / 100)`  
`cuota = total / personas`

- Caso 1: `100 × (1 + 10/100) = 110`; `110 / 4 = 27.50`.
- Caso 2: `90 × (1 + 0/100) = 90`; `90 / 3 = 30.00`.
- Caso 3: se rechaza `personas = 0`; no se divide.
- Caso 4: `abc` no produce un número finito; se informa `Monto inválido`.
- Caso 5: `10 / 3 = 3.333…`; a centavos = `3.33`.
- Caso 6: `ceil(10 / 3) = 4.00`; cobro agregado `4 × 3 = 12`; diferencia
  `12 - 10 = 2`, es decir, `2/10 × 100 = 20%` del monto base. No es propina
  adicional: es el efecto del redondeo de la cuota uniforme.
