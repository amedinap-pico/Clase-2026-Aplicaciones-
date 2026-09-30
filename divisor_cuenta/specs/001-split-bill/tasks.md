# Tareas: División de cuenta

**Documentos de entrada**: [plan.md](plan.md), [spec.md](spec.md)  
**Alcance**: implementación incremental de una pantalla, sin persistencia ni dependencias nuevas.

## Convenciones

- Marcar una tarea `[P]` solo cuando pueda realizarse en paralelo sin depender de otra tarea ni editar los mismos archivos.
- Las etiquetas `[US1]`, `[US2]` y `[US3]` relacionan cada tarea con las historias de usuario de `spec.md`.
- No se incluyen tareas de modificación de pruebas: el proyecto indica que no se modifique `test/` salvo petición expresa.
- `lib/data/` no requiere archivos mientras la funcionalidad no tenga una fuente de datos.

## Fase 1: Preparar las capas

**Propósito**: dejar creada la estructura mínima para implementar la funcionalidad sin romper la dirección de dependencias.

- [ ] T001 Crear las carpetas `lib/domain/entities/`, `lib/domain/services/` y `lib/presentation/pages/`.
- [ ] T002 Revisar `lib/main.dart` y preparar el punto de entrada para mostrar la pantalla de división desde `lib/presentation/pages/pantalla_division_cuenta.dart`.

## Fase 2: Dominio de cuenta y reparto

**Propósito**: establecer los datos y reglas monetarias que usará la pantalla.

- [ ] T003 [US1] Definir `Cuenta` en `lib/domain/entities/cuenta.dart` con el monto expresado en centavos y el porcentaje de propina permitido.
- [ ] T004 [US1] Definir `Reparto` en `lib/domain/entities/reparto.dart` con cantidad de personas, propina, total en centavos y pagos individuales en centavos.
- [ ] T005 [US1] Implementar en `lib/domain/services/calculadora_reparto.dart` el cálculo de propina y total, usando aritmética entera de centavos y sin importar `package:flutter`.
- [ ] T006 [US3] Añadir validaciones del dominio para monto no negativo, porcentaje permitido y cantidad de personas entera positiva; representar los errores de forma que presentación pueda mostrarlos.
- [ ] T007 [US3] Implementar el reparto de centavos residuales en `lib/domain/services/calculadora_reparto.dart`, garantizando que los pagos sumen el total y difieran como máximo un centavo.

## Fase 3: Historia US1 — Dividir la cuenta (Prioridad P1)

**Objetivo**: ingresar monto y número de personas para obtener el total y el pago individual.

- [ ] T008 [US1] Crear la pantalla única en `lib/presentation/pages/pantalla_division_cuenta.dart` con campos de monto y cantidad de personas.
- [ ] T009 [US1] Conectar las entradas válidas con `CalculadoraReparto` desde presentación y actualizar el resultado al cambiar los valores.
- [ ] T010 [US1] Mostrar el total con propina y los importes individuales de `Reparto` en la misma pantalla.

**Punto de revisión**: contrastar manualmente 120 unidades, 3 personas y 10%: total 132 y pago de 44 por persona.

## Fase 4: Historia US2 — Elegir la propina (Prioridad P2)

**Objetivo**: seleccionar 10%, 15% o 20% y actualizar total y pagos automáticamente.

- [ ] T011 [US2] Añadir a `lib/presentation/pages/pantalla_division_cuenta.dart` un selector exclusivo de 10%, 15% y 20%, con 10% seleccionado inicialmente.
- [ ] T012 [US2] Enviar el porcentaje seleccionado a `CalculadoraReparto` y refrescar los resultados al cambiarlo.

**Punto de revisión**: contrastar manualmente cuenta 200 y 4 personas: al 10%, total 220 y pago 55; al 15%, total 230 y pago 57,50; al 20%, total 240 y pago 60.

## Fase 5: Historia US3 — Obtener un reparto válido (Prioridad P3)

**Objetivo**: impedir resultados engañosos mientras los datos sean incompletos o inválidos y conservar el total ante fracciones de centavo.

- [ ] T013 [US3] Validar en `lib/presentation/pages/pantalla_division_cuenta.dart` el texto del monto y de la cantidad de personas, incluyendo campo vacío, texto no numérico, monto negativo y cantidad no entera.
- [ ] T014 [US3] Mostrar mensajes de corrección y no presentar el reparto como válido mientras haya entradas incompletas o inválidas.
- [ ] T015 [US3] Mostrar todos los pagos individuales cuando el reparto requiera distribuir centavos residuales, conservando el total mostrado.

**Punto de revisión**: contrastar manualmente total 11 y 3 personas: pagos 3,67, 3,67 y 3,66, cuya suma es 11.

## Fase 6: Integración y revisión

**Propósito**: cerrar el flujo y confirmar las restricciones de arquitectura del plan.

- [ ] T016 Conectar `lib/main.dart` con la pantalla de división y confirmar que el flujo completo ocurre en una sola pantalla.
- [ ] T017 Revisar que los archivos de `lib/domain/` no importen Flutter y que presentación dependa del dominio, sin dependencias en sentido inverso.
- [ ] T018 Revisar los criterios de aceptación y casos límite de `spec.md` mediante los puntos de revisión anteriores; confirmar que no se añadieron paquetes ni se modificaron `test/`, `android/` o `ios/`.

## Orden de ejecución

1. Completar T001–T002 para preparar capas y entrada.
2. Completar T003–T007 para terminar el dominio antes de conectarlo a la interfaz.
3. Completar T008–T010 para entregar primero el flujo principal P1.
4. Completar T011–T012 para agregar selección de propina P2.
5. Completar T013–T015 para cerrar validaciones y reparto de centavos P3.
6. Completar T016–T018 para integrar y revisar arquitectura y aceptación.

Las tareas de interfaz comparten `pantalla_division_cuenta.dart` y se ejecutan en el orden indicado. La capa `data` queda vacía porque el alcance no requiere guardar ni recuperar datos.
