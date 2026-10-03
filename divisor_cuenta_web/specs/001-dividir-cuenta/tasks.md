# Tareas: División de cuenta web

**Parte 3 del Deber 2**  
**Documentos de entrada:** [requirements.md](requirements.md) y
[analysis.md](analysis.md)  
**Estado:** Implementación y verificaciones iniciales completadas.

## Preparación del proyecto

- [x] Inicializar React + Vite e instalar dependencias.
- [x] Preparar las carpetas `src/data/`, `src/domain/` y
  `src/presentation/`.
- [x] Verificar que la base inicial pasa `npm run lint` y `npm run build`.
- [x] Implementar el divisor de cuenta descrito en los requerimientos.

## Dominio y reglas — CÓMO

- [x] Definir el modelo de entrada de cuenta y el contrato de estrategia de
  redondeo en `src/domain/`. *(RF-04–RF-07)*
- [x] Implementar la validación de monto finito y no negativo, personas como
  entero positivo y propina finita y no negativa. *(RF-07, RF-08)*
- [x] Implementar el cálculo del total con propina y la cuota por persona;
  delegar el redondeo sin acoplar el caso de uso a una implementación
  concreta. *(RF-04)*
- [x] Implementar el redondeo exacto al centavo y el redondeo hacia arriba al
  entero monetario siguiente. *(RF-05, RF-06, RF-10)*

## Presentación — CÓMO

- [x] Construir el formulario en `src/presentation/` con etiquetas y controles
  para monto, personas, propina y modo de redondeo. *(RF-01, RF-02, RC-04)*
- [x] Inicializar la propina en 10%, seleccionar modo exacto y dejar monto y
  personas sin valor. *(RF-01, RF-02)*
- [x] Conectar **Calcular** con la validación y el cálculo; actualizar el estado
  visible solo después de activar la acción. *(RF-03, RF-04)*
- [x] Mostrar errores en español y ocultar cualquier resultado cuando la
  validación falle. *(RF-08)*
- [x] Mostrar el pago individual con dos decimales cuando la entrada sea
  válida. *(RF-09)*
- [x] Adaptar la presentación para móvil y escritorio y comunicar los errores
  de forma accesible. *(RC-03, RC-04)*

## Verificación y entrega

- [x] Verificar los escenarios de aceptación 1 y 2: cálculo con propina y sin
  propina, respectivamente. *(RF-01–RF-05, RF-09)*
- [x] Verificar los escenarios 3 y 4: personas en cero y monto no numérico;
  confirmar que el error evita mostrar resultado. *(RF-07, RF-08)*
- [x] Verificar los escenarios 5 y 6: diferencia entre redondeo exacto y hacia
  arriba; confirmar que se muestra una cuota uniforme sin redistribución.
  *(RF-05, RF-06, RF-09, RF-10)*
- [x] Añadir y ejecutar pruebas automatizadas para las reglas de dominio con
  Node.js y los escenarios de presentación con Vitest, jsdom y Testing Library.
- [x] Revisar que no haya persistencia ni solicitudes de red en el alcance
  implementado. *(RC-01, RC-02)*
- [x] Ejecutar `npm test`, `npm run lint` y `npm run build`.

## Criterios de cierre

- Los seis escenarios de aceptación de `requirements.md` pasan.
- Una entrada inválida muestra el mensaje correspondiente y no conserva un
  resultado previo.
- La arquitectura mantiene separadas presentación, dominio e implementaciones
  de redondeo; el dominio no depende de React.
- No se añaden funciones fuera del alcance ni dependencias no aprobadas.
- Lint y build terminan correctamente.
