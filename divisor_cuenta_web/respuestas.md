# Respuestas — Deber 2: Divisor de cuenta

Las preguntas siguientes reproducen las seis preguntas de la sección
**“Preguntas”** de `Deber2.md`.

## 1. ¿Qué porcentaje de la spec viajó intacto, qué porcentaje necesitó adaptación y qué porcentaje no pudo reutilizarse?

**Datos observados:** la copia React está en
[`specs/001-dividir-cuenta/spec.md`](specs/001-dividir-cuenta/spec.md) y su
fuente está en
[`../divisor_cuenta/specs/001-split-bill/spec.md`](../divisor_cuenta/specs/001-split-bill/spec.md).
En esta revisión ambos archivos tienen el mismo SHA-256:

```text
011DF4F82AA270D6469C3B84F44F992E9048439C998CA284FA3A06452DAE7897
```

El contenido de la copia está intacto. El diff se verificó al crearla en esta
revisión y no mostró cambios. No se guardó evidencia de un diff inicial previo
a la planificación React, por lo que no afirmo que ese control histórico se
haya hecho antes.

**Estimación por enunciados:** [analisis_spec.md](analisis_spec.md) explicita
28 enunciados semánticos, agrupa requisitos repetidos y los clasifica por tipo
y viaje:

| Estado de viaje | Enunciados | Cálculo | Porcentaje |
|---|---:|---:|---:|
| Intacto | 23 | 23 / 28 × 100 | 82.14% |
| Con adaptación | 5 | 5 / 28 × 100 | 17.86% |
| No reutilizable | 0 | 0 / 28 × 100 | 0% |

Las adaptaciones corresponden a referencias de arquitectura/tecnología (Dart,
carpetas de presentation/data/domain, punto de composición) y a la traducción
del mecanismo de pruebas. Sobrevive el significado; cambia su realización. La
especificación de comportamiento y sus criterios no fueron modificados.

El tiempo no se registró con el cronómetro y no se usa como evidencia ni como
criterio de calidad.

## 2. En la Constitution, clasifica cada regla como idéntica, adaptada en redacción o reemplazada.

**Datos observados:** Flutter conserva sus reglas en
[`../divisor_cuenta/.specify/memory/constitution.md`](../divisor_cuenta/.specify/memory/constitution.md).
La versión web, creada de acuerdo con las reglas que la guía del deber pide,
está en [`.specify/memory/constitution.md`](.specify/memory/constitution.md).
La comparación detallada regla por regla está en
[`analisis_spec.md`](analisis_spec.md).

| Regla de Flutter | Clasificación | Evidencia/adaptación en React |
|---|---|---|
| SRP: separar UI, entidades y reglas de negocio. | Adaptada en redacción | La UI pasa a componentes/hook; las reglas permanecen en `src/domain/`. |
| OCP: agregar estrategias sin editar el cálculo existente. | Idéntica | `CalcularDivision` recibe una estrategia por parámetro. |
| LSP: estrategias sustituibles con resultados conformes. | Idéntica | Hay contrato común, dos estrategias y prueba de sustitución. |
| ISP: contratos pequeños. | Idéntica | El contrato de redondeo expone la operación requerida. |
| DIP: presentation apunta al dominio y el dominio no depende de Flutter. | Adaptada en redacción | La regla web prohíbe importar React/DOM en `src/domain/`; las dependencias apuntan al dominio. |
| Flutter/Dart y null safety. | Reemplazada | La plataforma requerida es React/Vite y JavaScript; el dominio valida en runtime. |
| Nombres de clases, variables y métodos en español. | Idéntica | La lógica y la UI usan nombres/mensajes en español, exceptuando APIs externas. |
| No dependencias externas sin autorización. | Idéntica con excepción de desarrollo | React/Vite son el stack requerido; Vitest, jsdom y Testing Library son dependencias de desarrollo agregadas para probar UI conforme a la consigna. |
| Capas en `lib/` y no crear infraestructura sin fuente externa. | Adaptada en redacción | Las carpetas pasan a `src/`; `data` alberga estrategias locales, sin API. |
| Cuota por persona sin redistribuir residuos. | Idéntica | RF-10 conserva el ejemplo 10/3 → 4.00 por persona. |
| No tocar `test/`, `android/`, `ios/` sin solicitud. | Reemplazada | Las plataformas Flutter no pertenecen al proyecto React; la guía sí exige crear pruebas web. |
| `flutter analyze` y `flutter test`. | Adaptada en redacción | Se usan `npm run lint`, `npm test` y `npm run build`. |
| Gobierno: explicar excepciones en el plan. | Idéntica | El plan documenta decisiones y límites de evidencia. |
| No guardar secretos/API keys. | Nueva por requisito de la guía web | No existe equivalente explícito en la Constitution Flutter revisada. |
| Funcionalidad crítica y criterios de aceptación con pruebas. | Nueva por requisito de la guía web | Regla pedida para la Constitution React; la original prescribe verificaciones, pero no esta regla general con esa redacción. |
| El estudiante debe poder explicar el código generado. | Nueva por requisito de la guía web | Regla pedagógica específica del deber, sin equivalente literal en la fuente. |

Las tres reglas nuevas no se atribuyen a la Constitución original: las exige la
guía de React. La adaptación se documenta como archivo inicial y no como una
ratificación de Spec Kit; no se afirma que se haya ejecutado
`/speckit-constitution`.

## 3. ¿Tuviste que modificar algún enunciado de la spec para implementar React?

No. La copia de la spec se creó sin cambiar su contenido y coincide con el
archivo Flutter según el SHA-256 indicado en la pregunta 1. Las menciones a
Dart y `main.dart` describen la arquitectura del proyecto de origen, pero no
impiden implementar el comportamiento en React. Se adaptan en el plan y la
Constitution web —por ejemplo, `main.dart` se traduce a `main.jsx`—, no en la
copia de la spec.

**Límite de evidencia:** aunque la comparación actual es exacta, no se guardó un
diff vacío antes de iniciar la implementación. Por tanto, el estado actual se
puede verificar; no se puede demostrar retrospectivamente el orden temporal
que pide el protocolo de la guía. No existe cambio de spec separado ni se
afirma que se haya ejecutado `/speckit-analyze`.

## 4. Compara los seis casos de aceptación de Flutter y React. ¿Cambió algún valor esperado, mensaje o escenario?

**Datos observados:** los seis enunciados originales están en
[`specs/001-dividir-cuenta/spec.md`](specs/001-dividir-cuenta/spec.md). Los
resultados y mensajes documentados son:

| Caso | Flutter | React | ¿Cambió? |
|---:|---|---|---|
| 1 | 100.00, 4, 10%, exacto → 27.50 | Igual → 27.50 | No |
| 2 | 90.00, 3, 0%, exacto → 30.00 | Igual → 30.00 | No |
| 3 | 50.00, 0 personas → `Debe haber al menos una persona`, sin resultado | Igual mensaje, sin resultado | No |
| 4 | Monto no numérico → `Monto inválido` | Igual mensaje | No |
| 5 | 10.00, 3, 0%, exacto → 3.33 | Igual → 3.33 | No |
| 6 | Mismos datos, hacia arriba → 4.00 | Igual → 4.00 | No |

Los seis casos están ahora en [`test/casosDePrueba.js`](test/casosDePrueba.js)
y se recorren en [`test/division.test.js`](test/division.test.js) con Vitest;
la prueba de pantalla [`test/pantalla.test.jsx`](test/pantalla.test.jsx)
verifica los tres flujos requeridos por la guía. No cambió ningún valor,
mensaje o escenario por la tecnología. La salida final de `npm test` se
registrará en [bitacora.md](bitacora.md).

## 5. ¿Qué partes del plan Flutter dejaron de tener sentido en React?

**Datos observados:** el plan de Flutter está en
[`../divisor_cuenta/specs/001-split-bill/plan.md`](../divisor_cuenta/specs/001-split-bill/plan.md);
el plan web, preparado en esta revisión, está en
[`specs/001-dividir-cuenta/plan.md`](specs/001-dividir-cuenta/plan.md).

1. **Widgets y `main.dart`:** el plan Flutter prescribe
   `PantallaDivisor`, `DivisorController` y composición en `main.dart`. React
   usa `PantallaDivisor.jsx`, `useDivisor.js`, componentes HTML y composición
   en `src/main.jsx`. El rol de presentación y composición se mantiene; las
   clases base y widgets no aplican.
2. **Dart y null safety:** `package:flutter`, tipos Dart y null safety dejan
   de ser ejecutables en una app JavaScript. Se usan módulos ES y validación
   con `Number.isFinite`, `Number.isInteger` y controles explícitos en runtime.
3. **Verificación Flutter/plataformas:** `flutter test`, `flutter analyze` y
   build APK no verifican el artefacto React. Se sustituyen por Node/Vitest,
   Oxlint y `vite build`; no se necesita `android/` ni `ios/`.
4. **Formato/controlador Flutter:** `FormateadorMoneda` y `DivisorController`
   eran clases Dart de presentación. React coordina el estado con `useDivisor`
   y formatea mediante `src/presentation/formateadorMoneda.js`. Se conserva la
   responsabilidad, no la clase/framework original.

El plan web se redactó ahora para el stack React. No se encontró un plan web
anterior con líneas que se pudieran comparar físicamente; tampoco se afirma
que se haya generado con `/speckit-plan`.

## 6. ¿Qué artefacto fue el más reusable y cuál el menos reusable?

**Más reusable: la especificación funcional y sus criterios de aceptación.**
La copia actual conserva exactamente el contenido fuente (mismo SHA-256), y
las seis pruebas de presentación React comprueban los mismos resultados y
mensajes. Se adapta el entorno del test, no el significado de los escenarios.

**Menos reusable: el código de implementación Flutter y las decisiones de su
plan.** Los widgets, `main.dart`, los tipos/imports Dart, `flutter_test`, el
analizador Flutter y el build APK dependen de la plataforma de origen y se
reemplazan con React/JSX, Node/Vitest, Oxlint y Vite. La estructura funcional
por capas sirve de guía, pero la implementación se vuelve a escribir. El
historial muestra el proyecto web separado; no hay una comparación de diff de
código Flutter/React equivalente que permita atribuir líneas idénticas.

No se usa tiempo como evidencia: el tiempo del cronómetro no fue registrado.
