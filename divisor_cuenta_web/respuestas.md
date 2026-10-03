# Respuestas fundamentadas — Deber 2

> **Alcance de estas respuestas:** en la carpeta disponible no se encontró el
> texto literal de las seis preguntas del profesor. Estas seis respuestas
> organizan los seis temas documentados en el archivo de respuestas de la
> práctica Flutter original. Si la guía del profesor usa preguntas distintas,
> se debe contrastar este borrador con esa guía antes de entregar.

## 1. ¿Qué partes de la especificación expresan QUÉ, CÓMO o una mezcla?

**Datos observados.** La spec original contiene seis escenarios con datos y
resultados esperados; restricciones como entradas finitas/no negativas,
mensajes de error, cuota a dos decimales, funcionamiento sin conexión y no
redistribución. También contiene decisiones de capas (`domain`, `data`,
`presentation`), dependencia `presentation -> domain <- data` y composición
desde `main.dart`.

**Análisis.** Los primeros describen comportamiento observable (**QUÉ**); la
organización por capas y el ensamblaje describen diseño (**CÓMO**). Hay
enunciados **MIXTOS**: por ejemplo, exigir una sola pantalla con botón nombra
controles concretos (CÓMO) y a la vez una acción de usuario (QUÉ). En
[`analisis_spec.md`](analisis_spec.md) se enumeran 23 unidades: 16 QUÉ (69.57%),
4 CÓMO (17.39%) y 3 MIXTOS (13.04%). El porcentaje es proporción de enunciados,
no calificación ni cobertura.

## 2. ¿Cómo se adaptó la Constitution y qué evidencia hay de SOLID?

**Datos observados.** La Constitución fuente prescribe SRP, OCP, LSP, ISP y DIP,
el dominio sin Flutter, capas separadas y una cuota uniforme. En la web,
`src/domain/calcularDivision.js` recibe la estrategia como argumento; las
implementaciones están en `src/data/`; `src/main.jsx` construye las
implementaciones y las inyecta a `App`. `test/domain.test.js` contiene una
prueba de estrategias intercambiables.

**Análisis.** La adaptación cambia Flutter/Dart por React/JavaScript y su
validación en tiempo de ejecución, pero mantiene responsabilidades y dirección
de dependencias. La prueba de intercambiabilidad respalda LSP de forma
ejecutable para un caso; no demuestra automáticamente todo el contrato.
`analisis_spec.md` documenta principio por principio y aclara que la adaptación
no se presenta como Constitución formalmente ratificada.

## 3. ¿Cómo se justifican los cálculos de propina y porcentajes?

**Datos observados.** La fórmula está en el requisito RF-04 y en
`src/domain/calcularDivision.js`: primero se incorpora el porcentaje de
propina, luego se divide, luego se redondea la cuota.

**Cálculos reproducibles.**

- `100 × 10% = 10`; `(100 + 10) / 4 = 27.50`.
- `90 × 0% = 0`; `90 / 3 = 30.00`.
- `10 / 3 = 3.333…`; redondeo exacto a centavos = `3.33`.
- `ceil(10 / 3) = 4.00`; `4 × 3 = 12.00`, `2.00` más que la cuenta base,
  equivalente a `2 / 10 × 100 = 20%`.

**Análisis.** La diferencia de 20% es el efecto del redondeo uniforme hacia
arriba para ese ejemplo concreto; no significa que la propina sea 20% ni que
se aplique un recargo. La cuota uniforme es el requisito; no se redistribuyen
residuos.

## 4. ¿Qué viajó desde Flutter a la web, qué cambió y por qué?

**Datos observados.** La spec Flutter define los seis resultados, las
validaciones, el orden del cálculo, las dos políticas de redondeo y el modelo
de cuota por persona. La web documenta esos comportamientos en
`specs/001-dividir-cuenta/requirements.md` y los implementa en dominio, datos y
presentación.

| Viajó desde la referencia Flutter | Cambió en la versión web | Motivo |
|---|---|---|
| Cuenta, resultado, validación y cálculo separados de la UI. | Clases Dart pasan a módulos JavaScript en `src/domain/`. | Adaptar idioma y plataforma, conservar responsabilidades. |
| Contrato de estrategia y modos exacto/hacia arriba. | Estrategia JS con método `redondear`, implementada en `src/data/`. | Mantener sustitución de políticas en la arquitectura React. |
| Pantalla única con tres entradas, selector y acción. | Widgets Flutter pasan a componentes React/HTML accesibles. | La tecnología de presentación es distinta. |
| Mensajes y cuota uniforme, sin ajuste de residuos. | UI en español y resultado con `toFixed(2)`. | Conservar el contrato visible y el formato de dos decimales. |
| Escenarios de prueba Flutter. | Node `node:test` para dominio y Vitest/Testing Library para presentación. | Usar runners apropiados para JavaScript y verificar comportamiento web. |

**Análisis.** Viajó el contrato funcional y arquitectónico, no el código Dart
ni los widgets. El cambio de plataforma exige una traducción de implementación;
no justifica alterar los resultados.

## 5. ¿Qué evidencia demuestra que los escenarios y la interfaz funcionan?

**Datos observados.** `test/domain.test.js` declara casos para 27.50, 30.00,
3.33, 4.00, cero personas, monto no numérico, validaciones y sustitución de
estrategias. `test/pantalla.test.jsx` prueba valores iniciales y los seis
escenarios de aceptación en UI, incluidos la desaparición del resultado ante
error y el selector de redondeo. El script `npm test` ejecuta Node y Vitest en
secuencia.

**Ejecución registrada.** En la bitácora de esta entrega se registran
ejecuciones con 8 pruebas de dominio y 6 pruebas de interfaz exitosas, junto
con `npm run build` exitoso. La bitácora también separa las ejecuciones
observadas en sesiones anteriores de las pruebas posteriores a la creación de
estos documentos.

**Análisis.** Esto demuestra los ejemplos automatizados en el entorno de
ejecución registrado; no equivale a certificar todos los navegadores, monedas
o entradas regionales, que no forman parte del alcance.

## 6. ¿Qué se puede afirmar sobre iteraciones y control de versiones?

**Datos observados al preparar estos documentos.** La rama actual se identificó
como `sdd`; existen ramas locales `backend`, `main`, `sdd` y `vibe`. `git
status --short --untracked-files=all -- .` muestra los archivos del proyecto
web sin seguimiento. `git log --all -- .` devuelve commits generales de
sesiones, pero no hay commits que registren los archivos web en el historial
porque siguen sin seguimiento. No se hizo `git add` ni commit al crear esta
entrega.

**Datos de la práctica previa, no revalidados como historia de este proyecto.**
El `divisor_cuenta/respuestas.md` original registra una comparación entre
`vibe` y `sdd`: 52 archivos, 5,442 inserciones y 390 eliminaciones en el diff
de aquella práctica, además de 1 archivo Dart/354 líneas frente a 11
archivos/221 líneas. Esos números describen el proyecto Flutter y no se deben
atribuir a la migración web.

**Análisis.** No hay registro cuantificable de iteraciones del estudiante en
los artefactos disponibles. No es válido inferir número de iteraciones a partir
de los turnos del asistente. Antes de entregar, conviene revisar el historial
de la clase y, si corresponde, agregar/confirmar estos artefactos siguiendo las
reglas del repositorio; aquí se deja constancia de que permanecen sin
seguimiento.
