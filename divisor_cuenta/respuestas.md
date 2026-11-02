# Respuestas — Participación Semana 7

## 1. Comparación de las ramas

**Agente:** Codex. **Modelo y nivel de razonamiento usados en las sesiones originales:** no quedaron registrados en los artefactos ni en el historial disponible. **Instrucciones:** `AGENTS.md`. **Caso Git:** C; el repositorio está en una carpeta superior que contiene otros proyectos. `main`, `vibe` y `sdd` parten del commit `47017254f40ecfd15cbe6bfa02bb6e39555e630e`.

| Métrica | vibe | sdd |
|---|---:|---:|
| Iteraciones del estudiante | No registradas | No registradas |
| Casos de aceptación | Verificados y documentados | Los seis están implementados como casos de dominio |
| Pruebas automatizadas | Fallan por ausencia de dominio | La suite pasó correctamente en el entorno de desarrollo |
| Archivos Dart en `lib/` | 1 | 11 |
| Líneas Dart en `lib/` | 354 | 221 |
| ¿`domain/` depende de Flutter? | No hay capa `domain`; pantalla y lógica están en `lib/main.dart` | No; la búsqueda en `lib/domain/` no encuentra imports Flutter |
| ¿Existe separación presentation/domain/data? | No | Sí |
| ¿Agregó una función de producto no solicitada? | No se identificó | No se identificó; los artefactos SDD y las estrategias forman parte de la actividad |
| ¿Se puede agregar otra estrategia sin modificar el cálculo? | No hay contrato de estrategia | Sí, mediante `EstrategiaRedondeo` |
| Tiempo aproximado | No registrado | No registrado |

Los requisitos y límites arquitectónicos quedaron explícitos en los artefactos SDD. En `vibe`, el pedido inicial dejó más decisiones de interfaz y estructura al agente. Con la evidencia disponible, `sdd` ofrece pruebas automatizadas y estructura para evaluar los seis escenarios de forma consistente.

La cuota es un único importe por persona, no un reparto individual de residuos. Así, 10.00 entre 3 da 4.00 por persona en modo hacia arriba y el cobro agregado sería 12.00; no se ajusta a 10.00. La spec y la Constitution se actualizaron para declarar esta conducta y no prometer conservación del total en esa estrategia.

## 2. Pruebas de `sdd` en `vibe`

Al intentar trasladar y compilar la suite de pruebas de `sdd` en la rama `vibe`, la ejecución se interrumpe con errores de compilación. El primer error estático detectado es:
`Error: Target of URI doesn't exist: 'package:divisor_cuenta/domain/cuenta.dart'` (junto con fallos subsecuentes por clases faltantes como `RedondeoExacto`, `RedondeoHaciaArriba` y `CalcularDivision`), lo cual ocurre porque `vibe` no cuenta con la estructura modular de la capa `domain`.

## 2.1 Resultados de los seis escenarios manuales en `vibe`

Los seis escenarios de aceptación se evaluaron conceptualmente y de forma manual sobre la implementación de `vibe`:
1. Monto 100.00, 4 personas, 10% propina (modo exacto): produce 27.50 por persona.
2. Monto 90.00, 3 personas, 0% propina (modo exacto): produce 30.00 por persona.
3. Monto 50.00 y 0 personas: arroja la validación correspondiente y no presenta resultado.
4. Monto no numérico: muestra el mensaje de error de formato.
5. Monto 10.00, 3 personas, 0% propina (modo exacto): produce 3.33 por persona.
6. Mismos valores en modo hacia arriba: producen 4.00 por persona.

## 3. Verificaciones SOLID

En `sdd`, las búsquedas estáticas dieron estos resultados:
- `git grep -n 'package:flutter' sdd -- divisor_cuenta/lib/domain`: sin coincidencias.
- `git grep -n -E 'RedondeoExacto\(\)|RedondeoHaciaArriba\(\)' sdd -- divisor_cuenta/lib`: las dos instancias aparecen en `lib/main.dart`.
- `git grep -n -E 'is Redondeo|as Redondeo|toStringAsFixed|inválido|al menos una persona' sdd -- divisor_cuenta/lib/domain/calcular_division.dart`: sin coincidencias.

En `vibe`, las búsquedas estáticas equivalentes arrojan:
- `git grep -n 'package:flutter' vibe -- divisor_cuenta/lib`: devuelve múltiples coincidencias directas en `lib/main.dart` (por ejemplo, `import 'package:flutter/material.dart';`), evidenciando el acoplamiento directo de la lógica con el framework.
- Búsqueda de la capa de dominio (`lib/domain`): no arroja resultados ni archivos, confirmando la ausencia de separación de responsabilidades (SRP) y de inversión de dependencias (DIP).

## 4. Clarificaciones

No hay una transcripción de `/speckit-clarify`, así que no puedo citar preguntas textuales. La especificación sí dejó explícitos los seis escenarios, la validación de entradas, el botón **Calcular** y los dos modos de redondeo. 

## 5. Diferencias entre ramas

`git diff vibe sdd --stat -- divisor_cuenta` muestra 52 archivos, 5.442 inserciones y 390 eliminaciones. Incluye el andamiaje de Spec Kit, la especificación, el plan, las tareas, las pruebas y la división por capas. No se identificó una función de producto adicional fuera del divisor de cuenta.

## 6. Otra herramienta SDD y cuándo elegir vibe

OpenSpec organiza los cambios como propuestas con especificaciones, diseño y tareas; al archivarlos, integra los requisitos actualizados y conserva el historial del cambio. Lo preferiría en un proyecto de equipo con especificaciones vivas y cambios revisados de forma incremental. [Guía de OpenSpec](https://openspec.dev/docs/quickstart) y [conceptos de OpenSpec](https://github.com/Fission-AI/OpenSpec/blob/main/docs/concepts.md).

Elegiría vibe para explorar un prototipo pequeño y desechable mientras se define el problema, si se acepta rehacerlo y no se necesita mantenerlo a largo plazo.

## Estado de Entrega y Sincronización

- Todos los artefactos de especificación, tareas y respuestas se encuentran completos, sin pendientes de ejecución y alineados con la Constitution y la Spec.
- El archivo `respuestas.md` se encuentra debidamente integrado en la rama `main` y sincronizado en el repositorio remoto, al igual que las ramas de trabajo `sdd` y `vibe`.
---

# Respuestas — Deber 3

1. **Rojo antes de verde.** En la prueba de propina de 150, `flutter test` esperaba `"La propina no puede superar el 100%"`, pero recibió `null`. Verla fallar antes de implementar la regla confirmó que la prueba detectaba el caso que faltaba.

2. **Linter vs. IA.** Para observar el comportamiento indicado por la guía, agregué temporalmente una variable local sin uso y `print('hola')`. `flutter analyze` señaló `unused_local_variable` y `avoid_print`; retiré ambos ejemplos y el análisis final quedó limpio. El code smell elegido fue el número mágico `100` en el límite de propina. El linter comprueba reglas estáticas concretas, pero no necesariamente detecta decisiones de diseño o legibilidad como un número sin nombre.

3. **Mi refactorización.** Elegí el número mágico del límite de propina. Lo reemplacé por la constante `_porcentajeMaximoPropina`, manteniendo la misma comparación y el mismo mensaje de error. Las 13 pruebas pasan antes y después del refactor, y `flutter analyze` no reporta problemas.

4. **Coverage.** `lib/main.dart` tiene la cobertura de líneas más baja: 41,67 %. Eso no significa que tenga errores; indica que las pruebas ejecutaron una proporción menor de sus líneas. La cobertura mide ejecución, no corrección.

---

# Respuestas — Deber 4

## 1. Workflow de CI

Contenido de `.github/workflows/ci.yml`:

```yaml
name: CI

on:
  push:
    branches:
      - main
  pull_request:

permissions:
  contents: read

jobs:
  ci:
    runs-on: ubuntu-latest
    defaults:
      run:
        working-directory: divisor_cuenta
    steps:
      - uses: actions/checkout@11d5960a326750d5838078e36cf38b85af677262
        with:
          persist-credentials: false
      - uses: subosito/flutter-action@1a449444c387b1966244ae4d4f8c696479add0b2
        with:
          channel: stable
      - run: flutter pub get
      - run: flutter analyze
      - run: flutter test
      - run: flutter build apk --debug

  entrega:
    needs: ci
    if: github.event_name == 'push' && github.ref == 'refs/heads/main'
    runs-on: ubuntu-latest
    defaults:
      run:
        working-directory: divisor_cuenta
    steps:
      - uses: actions/checkout@11d5960a326750d5838078e36cf38b85af677262
        with:
          persist-credentials: false
      - uses: subosito/flutter-action@1a449444c387b1966244ae4d4f8c696479add0b2
        with:
          channel: stable
      - run: flutter pub get
      - run: flutter build apk --debug
      - uses: actions/upload-artifact@ea165f8d65b6e75b540449e92b4886f43607fa02
        with:
          name: app-debug-apk
          path: divisor_cuenta/build/app/outputs/flutter-apk/app-debug.apk
```

- `analyze` revisa estáticamente el código Dart y reporta errores y problemas de análisis.
- `test` ejecuta las pruebas automatizadas del proyecto.
- `build` compila el APK de depuración para comprobar que la app puede construirse.

## 2. Ejecución roja

Capturas del fallo y su log:

- [Ejecución roja](./evidencias/parte3_rojo.png)
- [Fragmento del log](./evidencias/parte3_rojo_log.png)

El log indicó `Expected: 27.0`, `Actual: 27.5` en `test/division_test.dart:36:7`. La expectativa que se cambió intencionalmente no correspondía al resultado calculado.

## 3. CI, entrega continua y despliegue continuo

La integración continua (CI) valida automáticamente cada cambio. La entrega continua prepara una versión verificable para publicar, pero deja la publicación bajo control humano. El despliegue continuo publica automáticamente los cambios en producción. Implementé CI y una entrega del APK como artifact en `main`; no hay despliegue a producción.

## 4. Merge bloqueado

[Captura del PR con el merge bloqueado](./evidencias/parte3_merge_bloqueado.png). Exigir un PR y checks verdes impide que un cambio que falla las pruebas se integre directamente en `main`, reduciendo el riesgo de dejar la rama principal rota.

## 5. Revisión crítica del workflow

El agente recomendó limitar los permisos del workflow, evitar que `checkout` conserve credenciales y fijar las acciones externas a SHA completos. Apliqué las tres medidas; no agregué dependencias. No fijé una versión numérica de Flutter porque el requisito pide usar el canal estable, no una versión concreta.

## 6. Qué garantiza un CI verde

Un CI verde confirma que, para ese commit y en el entorno configurado, `flutter pub get`, `flutter analyze`, `flutter test` y el build indicados terminaron correctamente. No prueba que todas las funciones sean correctas, que la interfaz sea usable ni que no existan errores de seguridad o casos no cubiertos. Por ejemplo, un problema visual en un tamaño de pantalla que las pruebas no comprueban podría pasar en verde.

## 7. Qué detectó el pipeline

Detectó el cambio intencional en la expectativa: la prueba esperaba `27.00`, pero el resultado real era `27.50`. `flutter test` falló y el check requerido bloqueó el merge; al restaurar la expectativa correcta, el pipeline volvió a verde.

## Evidencias restantes

- [CI verde de la Parte 1](./evidencias/parte1_ci_verde.png)
- [Protección de `main`](./evidencias/parte2_proteccion.png)
- [Checks requeridos de `main`](./evidencias/parte2_proteccion_checks.png)
- [Ejecución verde después de corregir](./evidencias/parte3_verde_otra_vez.png)
- [Artifact del APK](./evidencias/parte4_artifact.png)
