# Plan de implementación: División de cuenta

**Rama**: `001-split-bill`  
**Fecha**: 2026-09-30  
**Especificación**: [spec.md](spec.md)

## Resumen

Implementar en una sola pantalla el ingreso del monto de una cuenta y la cantidad de personas, la selección de propina del 10%, 15% o 20% y el cálculo automático del total y de los pagos individuales. Las reglas monetarias, la validación y el reparto de centavos residuales vivirán en `domain`, aislados de Flutter. `presentation` recogerá las entradas y mostrará los resultados y errores. No se requiere persistencia ni una fuente de datos externa.

## Contexto técnico

- **Lenguaje y versión**: Dart con null safety, según la configuración existente del proyecto Flutter.
- **Dependencias principales**: Flutter y Dart ya configurados en el proyecto; no se agregan paquetes.
- **Almacenamiento**: No aplica; la cuenta se mantiene en memoria mientras se usa la pantalla.
- **Verificación prevista**: Casos de aceptación y reglas de validación/reparto; comandos del proyecto disponibles: `flutter analyze` y `flutter test`.
- **Plataforma**: Aplicación Flutter multiplataforma, con una pantalla.
- **Tipo de proyecto**: Aplicación móvil Flutter.
- **Rendimiento**: Recalcular al cambiar entradas válidas y actualizar la pantalla en menos de un segundo.
- **Restricciones**: Mantener la dirección `presentation -> domain <- data`; `domain` no importa Flutter. Usar nombres en español, null safety y no añadir dependencias.
- **Alcance**: Una cuenta activa; sin historial, almacenamiento, autenticación, ni asignación de consumos por persona.

## Comprobación de arquitectura

- La división por capas existente y requerida se respeta: presentación depende del dominio; datos solo se incorporan si una necesidad concreta los justifica.
- Las entidades y reglas de cálculo permanecen independientes de Flutter.
- No se prevé persistencia ni integración externa, por lo que no se necesita una implementación en `data` para este alcance.
- No se modifica `android/`, `ios/` ni `test/` como parte de este plan.

## Estructura propuesta

```text
lib/
├── domain/
│   ├── entities/
│   │   ├── cuenta.dart
│   │   └── reparto.dart
│   └── services/
│       └── calculadora_reparto.dart
├── data/                  # Sin implementación: no hay fuentes de datos en el alcance
└── presentation/
    ├── pages/
    │   └── pantalla_division_cuenta.dart
    └── widgets/            # Componentes de entrada y resultados, si hacen falta
```

**Decisión de estructura**: Organizar el código de la funcionalidad dentro de las capas requeridas en `lib`. La lógica monetaria pertenece al dominio; la pantalla y sus componentes, a presentación. Mantener `data` sin archivos para esta funcionalidad mientras no exista almacenamiento o integración que lo requiera. Reutilizar la configuración de entrada existente si el proyecto ya tiene una estructura concreta, sin introducir dependencias nuevas.

## Pasos de implementación

### 1. Modelar el dominio

- Definir `Cuenta` con monto base y porcentaje de propina permitido (10, 15 o 20).
- Definir `Reparto` con cantidad de personas, propina, total con propina y pagos individuales.
- Representar los importes con precisión de centavos, evitando que errores de punto flotante alteren el total.

### 2. Implementar reglas de cálculo y validación

- Crear una operación de dominio que reciba los datos vigentes y calcule propina y total.
- Validar monto numérico y no negativo, y cantidad de personas entera y positiva; no producir un reparto para datos inválidos.
- Aplicar el redondeo monetario a dos decimales y distribuir los centavos restantes entre pagos para que sumen exactamente el total y difieran como máximo un centavo.
- Devolver un resultado que permita a presentación distinguir cálculo válido de errores corregibles.

### 3. Construir la pantalla

- Crear una única pantalla con campos para monto y cantidad de personas, y opciones de propina 10%, 15% y 20%, con 10% inicial.
- Conectar los cambios de entrada con el cálculo del dominio para actualizar el resultado automáticamente.
- Mostrar la propina, el total final y el detalle/importe individual del reparto cuando los datos sean válidos.
- Mostrar mensajes claros junto a los datos que deban corregirse y ocultar o invalidar el resultado mientras falte un dato requerido.

### 4. Integrar y revisar los criterios de aceptación

- Confirmar que el flujo permanece en una sola pantalla y que cada cambio válido actualiza los resultados.
- Contrastar los valores de los ejemplos de la especificación: 120/3 al 10%, y 200/4 en cada porcentaje.
- Revisar datos vacíos, cero, negativos, no numéricos, cantidad fraccionaria y división con centavos residuales.
- Verificar que `domain` no importe `package:flutter` y que no se hayan añadido dependencias ni cambiado directorios de plataforma.

## Orden de dependencias

1. Dominio: entidades, validación, precisión monetaria y reparto.
2. Presentación: entradas, selección de propina, estados de error y resultados.
3. Integración: vincular la pantalla con el dominio y revisar los criterios de aceptación.

## Seguimiento de complejidad

No se identifican desviaciones de arquitectura ni necesidad de capas, paquetes o servicios adicionales para el alcance descrito.
