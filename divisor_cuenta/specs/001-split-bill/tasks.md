# Tareas: División de cuenta

**Documentos de entrada**: [plan.md](plan.md), [spec.md](spec.md)  
**Alcance**: una pantalla; sin persistencia ni dependencias nuevas.

## Dominio

- [x] Definir `Cuenta`, `Resultado` y `EstrategiaRedondeo` en `lib/domain/`.
- [x] Implementar `ValidarEntrada` para el monto, las personas y la propina.
- [x] Implementar `CalcularDivision` para sumar la propina, dividir entre personas y delegar el redondeo al contrato.

## Estrategias y presentación

- [x] Implementar `RedondeoExacto` y `RedondeoHaciaArriba` en `lib/data/`.
- [x] Crear `DivisorController` para coordinar validación y cálculo.
- [x] Crear `FormateadorMoneda` y una pantalla con entradas, selector de estrategia, botón Calcular y resultado o error.
- [x] Componer las estrategias concretas desde `lib/main.dart`.

## Verificación y entrega

- [x] Crear casos de dominio para los seis escenarios de aceptación.
- [x] Crear pruebas de sustitución de estrategias y de la pantalla.
- [x] Revisar estáticamente que `domain` no importe Flutter y que el cálculo no inspeccione tipos concretos.
- [x] Guardar la salida de `flutter test`, `flutter analyze` y `flutter build apk --debug`.
- [x ] Probar los seis escenarios en `vibe` y registrar los resultados.
- [x] Completar `respuestas.md` con datos personales, evidencia de ambas ramas y dejarlo en `main`.
- [x] Publicar las ramas requeridas en GitHub.

## Criterios de cierre

- Los seis escenarios tienen casos definidos en la suite de dominio.
- Las estrategias se pueden sustituir mediante `EstrategiaRedondeo`.
- Se conserva una sola pantalla, sin dependencias nuevas, y con las capas en la dirección establecida.