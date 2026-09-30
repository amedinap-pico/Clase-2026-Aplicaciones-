# Constitución del divisor de cuenta

## Principios

### I. Responsabilidad única (SRP)
Cada clase y archivo tendrá una responsabilidad principal. La interfaz recogerá entradas y mostrará resultados; las entidades representarán datos; el servicio de dominio validará y calculará el reparto. No se mezclarán widgets con reglas monetarias.

### II. Abierto/cerrado (OCP)
Las reglas de cálculo se ampliarán mediante una estrategia o implementación nueva cuando cambie una política variable, sin editar la política existente. La interfaz dependerá del contrato necesario y no codificará algoritmos de redondeo.

### III. Sustitución de Liskov (LSP)
Cualquier implementación de una abstracción de cálculo aceptará las mismas entradas válidas, respetará sus precondiciones y devolverá un reparto cuya suma sea el total. Ninguna implementación debilitará esas garantías.

### IV. Segregación de interfaces (ISP)
Las abstracciones expondrán solo las operaciones que necesita quien las consume. No se crearán interfaces genéricas con métodos ajenos al cálculo de una cuenta.

### V. Inversión de dependencias (DIP)
La presentación dependerá de contratos y entidades del dominio. El dominio no importará Flutter ni dependerá de presentación o datos. Las dependencias apuntarán hacia el dominio.

## Restricciones técnicas

- Usar Flutter y Dart con null safety, y nombres de clases, variables y métodos en español.
- No incorporar dependencias externas sin autorización.
- Mantener el código en `lib/presentation`, `lib/domain` y `lib/data` cuando corresponda. No crear infraestructura de datos sin una fuente externa que la justifique.
- Representar dinero en centavos enteros. La suma de pagos individuales debe coincidir con el total y la diferencia máxima entre pagos será un centavo.
- No modificar `test/`, `android/` ni `ios/` salvo solicitud expresa.

## Flujo y control de calidad

- La especificación define el comportamiento observable; el plan define la arquitectura; las tareas registran el avance.
- Antes de cerrar un cambio se revisarán los criterios de aceptación y la dirección de dependencias.
- Ejecutar `flutter analyze` y `flutter test` al verificar una implementación, respetando los límites de modificación de pruebas.

## Gobierno

Esta Constitución rige las decisiones de implementación de esta aplicación. Si una decisión futura contradice un principio, se actualizará esta Constitución y se explicará la excepción en el plan antes de implementar.

**Versión**: 1.0.0 | **Ratificada**: 2026-09-30 | **Última modificación**: 2026-09-30
