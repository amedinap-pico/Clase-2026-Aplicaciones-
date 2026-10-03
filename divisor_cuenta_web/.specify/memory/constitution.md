# Constitution — Divisor de cuenta web

Esta constitución adapta para React/Vite los principios y reglas indicados en
el Deber 2. Las referencias de Flutter/Dart se sustituyen por los equivalentes
web; no se agregan principios SOLID nuevos.

## Calidad de código — SOLID

### SRP — Responsabilidad única

Cada función o módulo tiene una razón principal de cambio. El cálculo no valida
entradas ni formatea el resultado.

### OCP — Abierto/cerrado

Agregar una nueva regla de redondeo no obliga a editar los módulos de cálculo
que ya existen.

### LSP — Sustitución de Liskov

Cualquier implementación del contrato de redondeo puede sustituir a otra sin
que quien la consume pregunte de qué tipo concreto es.

Cada estrategia acepta una cuota válida por persona y devuelve un resultado
finito, no negativo y conforme con la política declarada. El contrato devuelve
una cuota; no garantiza que la suma de cuotas recupere exactamente el total.

### ISP — Segregación de interfaces

Los contratos son pequeños; ningún consumidor depende de operaciones que no
usa.

### DIP — Inversión de dependencias

`presentation` depende de abstracciones de `domain`, nunca de implementaciones
concretas de `data`.

## Arquitectura

- Mantener las capas `src/presentation/`, `src/domain/` y `src/data/`.
- La dirección de dependencias es `presentation -> domain <- data`.
- `src/domain/` no importa `react` ni depende del DOM; es JavaScript puro.
- `src/main.jsx` es el único punto de composición que instancia
  implementaciones concretas de `data` durante la ejecución de la aplicación.
  Los archivos de pruebas pueden crear sus propias instancias de fixture.

## Seguridad

- Nunca guardar secretos ni API keys en el repositorio.

## Calidad y pruebas

- Toda funcionalidad crítica tiene pruebas.
- Los criterios de aceptación de la spec se convierten en pruebas ejecutables.

## Regla de la materia

Toda función generada por el agente debe poder ser explicada por el estudiante:
qué hace, por qué existe, qué recibe, qué devuelve y qué errores produce.
