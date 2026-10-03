# Bitácora de actividades — Deber 2

**Proyecto:** `divisor_cuenta_web`  
**Fecha de registro:** 2026-10-03  
**Zona horaria de las horas anotadas:** local (UTC-05:00).  
**Propósito:** registrar las actividades y verificaciones observadas en esta
sesión y las anteriores del proyecto; no sustituye el historial de Git.

## Registro de actividades

| Hora aproximada | Actividad y resultado |
|---|---|
| 13:25 | Se inspeccionó la carpeta web vacía y el repositorio; se inicializó React + Vite con la plantilla React JavaScript. |
| 13:26 | `npm install`: instaló dependencias; auditoría informó 0 vulnerabilidades. |
| 13:27 | `npm run build` y `npm run lint`: scaffold inicial compiló y pasó lint. |
| 13:28 | Se reemplazó la pantalla de bienvenida de Vite, se personalizó HTML/CSS y se preparó `src/data`, `src/domain` y `src/presentation`. |
| 13:29 | `npm run lint` y `npm run build`: ambos comandos terminaron correctamente en la base personalizada. |
| 13:36 | Se consultaron spec, plan, tareas, Constitution y código Flutter para crear documentación inicial del web. |
| 13:37 | Se crearon `specs/001-dividir-cuenta/requirements.md`, `analysis.md` y `tasks.md`; se enlazaron desde README. |
| 13:40 | Se implementaron modelos, validador, cálculo y estrategias de redondeo en JavaScript; se compuso el punto de entrada por inyección de dependencias. |
| 13:41 | Se implementaron hook y componentes de presentación, incluyendo formulario, errores accesibles y resultado. |
| 13:42 | Se añadió `test/domain.test.js` con el runner nativo de Node y script `npm test`. |
| 13:43 | `npm test`: 8 pruebas de dominio aprobadas, 0 fallidas. `npm run lint` y `npm run build`: finalizaron sin errores. |
| 13:43–13:44 | Se verificó en navegador el cálculo 27.50, los modos 3.33/4.00, errores de monto/personas y presentación en viewport móvil. |
| 13:45 | Se añadió Vitest, Testing Library y jsdom como dependencias de desarrollo; se adaptó `npm test` para correr dominio y UI. |
| 13:46 | `npm test`: 8 pruebas de dominio y 6 de interfaz aprobadas. `npm run lint` y `npm run build`: correctos. |
| 13:49 | Se amplió el README con requisitos del runtime, instrucciones de instalación, ejecución y arquitectura. |
| 13:53 | Se amplió la sección de calidad del README para describir las dos suites, lint y build. `npm test`: 8 pruebas de dominio y 6 de UI aprobadas. |
| 13:57 | Se comparó README con `specs/`; se documentaron requerimientos, seis escenarios, límites, dirección de dependencias y trazabilidad. Se actualizó el estado de `tasks.md`. `npm test`: 8 de dominio y 6 de UI aprobadas. |
| 13:58–14:00 | Se contrastaron fuentes Flutter, spec web, pruebas y Git para crear este análisis, respuestas y bitácora. Se dejó constancia explícita de las preguntas del profesor no incluidas y del estado sin seguimiento de los archivos. |

Las horas son aproximadas y reconstruidas de las marcas de tiempo disponibles
en la conversación/herramientas. No indican duración de trabajo humano ni
iteraciones del estudiante.

## Comandos de calidad registrados

| Comando | Evidencia registrada |
|---|---|
| `npm test` | Ejecutado después de la suite Node: 8 pruebas, 8 aprobadas, 0 fallidas. |
| `npm test` | Ejecutado después de incorporar Vitest: Node 8/8 y Vitest 6/6 aprobadas. |
| `npm run lint` | Finalizó sin errores en la implementación y en la configuración de pruebas. |
| `npm run build` | Vite generó `dist/` sin errores tras la implementación y la configuración de pruebas. |
| `npm run dev -- --host 127.0.0.1` | Servidor iniciado para comprobación de navegador y detenido al finalizar las verificaciones. |

Estas verificaciones corresponden al código existente antes de crear los tres
Markdown de entrega. Como esos cambios son solo documentación, no se volvió a
ejecutar build después de crearlos.

## Control de versiones

- **Repositorio Git:** raíz `Clase-2026-Aplicaciones-`.
- **Carpeta del proyecto:** `divisor_cuenta_web/`.
- **Rama actual observada:** `sdd`.
- **Otras ramas locales observadas:** `backend`, `main` y `vibe`.
- **Estado al redactar:** los archivos del proyecto web aparecían como `??`
  (untracked) en `git status --short --untracked-files=all -- .`.
- **Commits propios de estos archivos:** ninguno observado; no se ejecutó
  `git add`, `git commit`, push ni cambio de rama para esta entrega.

Por ese estado, los archivos están creados en el directorio de trabajo, pero
aún no constan como cambios staged o committeados. La presencia de commits de
sesión en `git log` no acredita que estos archivos formen parte de ellos.

## Fuentes y límites de evidencia

- Especificación fuente:
  [`divisor_cuenta/specs/001-split-bill/spec.md`](../divisor_cuenta/specs/001-split-bill/spec.md).
- Constitution fuente:
  [`divisor_cuenta/.specify/memory/constitution.md`](../divisor_cuenta/.specify/memory/constitution.md).
- Requerimientos y tareas web:
  [`specs/001-dividir-cuenta/requirements.md`](specs/001-dividir-cuenta/requirements.md),
  [`specs/001-dividir-cuenta/tasks.md`](specs/001-dividir-cuenta/tasks.md).
- Respuestas de la práctica Flutter anterior:
  [`divisor_cuenta/respuestas.md`](../divisor_cuenta/respuestas.md).
- No se encontró en el proyecto el enunciado literal de las seis preguntas,
  registro de iteraciones del estudiante ni historia committeada de los
  archivos web al momento de esta comprobación.
