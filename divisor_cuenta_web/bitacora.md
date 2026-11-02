# Bitácora — Deber 2

**Proyecto:** `divisor_cuenta_web`  
**Fecha:** 2026-10-03
**Horas locales:** UTC-05:00.

## Métricas obligatorias

| Métrica | Flutter (laboratorio) | React (este deber) | Evidencia/criterio |
|---|---|---|---|
| Minutos hasta primera compilación | No registrado | No registrado según el inicio oficial | La guía define inicio con `/speckit-plan`; ese inicio y el cronómetro no se registraron. Hubo builds exitosos, pero no tiempo transcurrido medido. |
| Minutos hasta que pasan los seis casos | No registrado | No registrado | No se inició/detuvo cronómetro con el criterio definido en la guía. |
| Iteraciones con el agente | No registrado | No registrado como métrica del estudiante | No hay registro contemporáneo que distinga correcciones del estudiante según la definición de la guía; no se infiere de los turnos. |
| Líneas de código escritas a mano por el estudiante | No registrado | No registrado | Los archivos del proyecto se generaron/editaron con asistencia; no hay conteo verificable de ediciones manuales del estudiante. |
| Enunciados de spec modificados | No registrado para el proceso inicial; 0 en la copia actual | 0 | `specs/001-dividir-cuenta/spec.md` es copia exacta de la fuente en la revisión actual; no se cambió ningún enunciado. No se afirma evidencia temporal previa. |
| Enunciados de Constitution modificados | No aplica | No aplica como conteo de edición | La Constitution React se crea en este deber; no existía una versión web previa que se editara. Su comparación regla por regla está en `analisis_spec.md`. |
| Líneas del plan React modificadas | No aplica | No aplica como edición de un plan React anterior | `plan.md` se crea en esta revisión; no existe línea base React previa. |
| Casos de aceptación que pasan (0–6) | No registrado aquí | 6/6 | Los seis casos pasan en la suite parametrizada de dominio; la suite de pantalla automatiza además los tres flujos que exige la guía. |

No se reemplazan los valores no medidos por estimaciones: la consigna pide
“No registrado” cuando la medición no existe.

## Actividades y evidencia de comandos

La bitácora anterior registró actividades aproximadas del scaffold, documentos,
implementación y configuración de pruebas. Esta tabla añade verificaciones
reproducidas el 2026-10-03 durante la corrección crítica. Los resúmenes no se
presentan como logs completos.

| Momento local | Comando/verificación | Resultado observado |
|---|---|---|
| 14:05 | `npm test` | Node: 8 tests, 8 pass, 0 fail. Vitest: 1 test file, 6 tests passed. |
| 14:05 | `npm run build` | Vite 8.3.2 transformó 27 módulos, generó `dist/` y terminó sin errores. |
| 14:05 | `npm run lint` | Oxlint terminó con exit code 0, sin diagnósticos. |
| 14:09 | Lectura de `Deber2.md` y comparación con archivos del proyecto | Se identificaron preguntas oficiales y brechas documentales/Spec Kit. |
| 14:10 | Copia de `spec.md` y comparación SHA-256 | Copia Flutter/React: `011DF4F82AA270D6469C3B84F44F992E9048439C998CA284FA3A06452DAE7897` en ambos archivos. |
| 14:10–14:12 | Creación de Constitución React, plan y revisión de respuestas/métricas | Archivos redactados; no se ejecutó Spec Kit CLI ni se modificó la spec copiada. |
| 14:12–14:14 | Ajuste a la estructura de prueba de la guía | Se creó el formateador, se cambió el contrato a `aplicar(valor)`, se consolidó dominio/UI en Vitest, y se añadieron casos parametrizados y setup jest-dom. |
| ~14:13 | `npm install --save-dev @testing-library/jest-dom` | Se añadieron matchers de DOM; auditoría de npm: 105 paquetes y 0 vulnerabilidades. |
| 14:14 | `npm test`, `npm run lint`, `npm run build` | Vitest: 2 archivos, 12 pruebas aprobadas; Oxlint sin diagnósticos; Vite compiló 28 módulos sin errores. |
| 14:14 | `git diff --no-index` de las dos specs | Salida vacía y código 0; hash SHA-256 idéntico. |
| 14:14 | `git diff --check` | Detectó un espacio final en esta bitácora; se eliminó. |
| 14:15 | `npm test` final | Vitest: 2 archivos, 12 pruebas aprobadas (9 de dominio y 3 de pantalla), 0 fallidas. |
| 14:15 | `npm run lint` final | Oxlint terminó con exit code 0, sin diagnósticos. |
| 14:15 | `npm run build` final | Vite 8.3.2 compiló 28 módulos; build de producción exitoso. |
| 14:15 | `git diff --check` final y revisión de espacios | Exit code 0; no quedan errores de whitespace en cambios seguidos ni en Markdown revisados. |
| 14:15 | `git grep` de imports React en domain | Sin coincidencias en `src/domain/`. |

La comprobación de hash demuestra identidad actual, no que el diff inicial se
haya capturado antes del trabajo React. Tampoco se generaron logs guardados en
archivo para adjuntar; se registra aquí el resumen observable de las salidas.

## Registro cronológico resumido

| Hora aproximada | Actividad |
|---|---|
| 13:25–13:29 | Scaffold de React/Vite, instalación y primeras verificaciones de build/lint. |
| 13:36–13:37 | Lectura de artefactos Flutter y creación de requerimientos, análisis y tareas web iniciales. |
| 13:40–13:44 | Implementación de dominio, estrategias, presentación y pruebas iniciales; validación de la app en navegador. |
| 13:45–13:46 | Incorporación de Vitest, Testing Library y jsdom; suite mixta de dominio/interfaz. |
| 13:49–13:57 | README extendido y comparación con `specs/`; pruebas automatizadas ejecutadas. |
| 13:58–14:04 | Análisis, respuestas y bitácora iniciales. |
| 14:04 | Commit local observado: `3f89f60`, documentación final previa. |
| 14:05–14:15 | Auditoría contra `Deber2.md`, re-ejecución de calidad y creación/adaptación de los artefactos faltantes. |

Las horas de actividades anteriores son aproximadas y se reconstruyeron a
partir de la conversación. No significan minutos cronometrados de trabajo.

## Control de versiones

- **Raíz Git:** `C:/Clase 2026 Aplicaciones/Clase-2026-Aplicaciones-`.
- **Carpeta de proyecto:** `divisor_cuenta_web/`; no es un repositorio Git
  independiente.
- **Rama observada:** `sdd`, configurada para `origin/sdd`.
- **Commit local de referencia al iniciar esta corrección:** `3f89f60`
  (`feat: completar documentacion final, analisis de spec, bitacora y respuestas`).
- En ese momento la rama estaba `ahead 1` respecto a `origin/sdd`; no se hizo
  push como parte de esta corrección.
- **Estado final observado:** 14 archivos modificados, 1 archivo eliminado
  (suite Node reemplazada por Vitest) y 7 archivos nuevos sin seguimiento,
  todos bajo `divisor_cuenta_web/`; ningún archivo de otro proyecto aparece en
  el estado filtrado de esta entrega.
- Los archivos de esta corrección (spec, Constitution, plan, respuestas,
  bitácora, análisis y cambios relacionados en pruebas/código) quedan
  pendientes de stage/commit. No se hizo commit final ni push.

**Estado listo para commit:** antes de confirmar, revisar el `git status`
actual, agregar solo los artefactos deseados y crear un commit descriptivo. No
se afirma que la entrega esté sincronizada con GitHub.

## Procesos Spec Kit y límites de evidencia

- No se ejecutaron ni quedaron evidencias de `specify init`, `/speckit-plan`,
  `/speckit-tasks`, `/speckit-analyze`, `/speckit-converge` o
  `/speckit-constitution`.
- `SPECIFY_FEATURE_DIRECTORY` no se configuró/registró en esta sesión.
- La copia de spec se hizo ahora desde la ruta fuente real
  `divisor_cuenta/specs/001-split-bill/spec.md`. El diff/hash actual es idéntico,
  pero no se conservó una comprobación inicial antes de planificar.
- No se encontraron el tiempo del cronómetro, conteo de iteraciones ni conteo
  de líneas manuales del estudiante; se reportan como no registrados.
