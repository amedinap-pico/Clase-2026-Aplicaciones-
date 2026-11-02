# Plan de implementación — Divisor de cuenta web

**Feature:** `001-dividir-cuenta`  
**Spec de entrada:** [spec.md](spec.md), copiada de la especificación Flutter
sin cambios de contenido.  
**Constitución:** [../../.specify/memory/constitution.md](../../.specify/memory/constitution.md)

## Resumen

Implementar en React/Vite una pantalla web local que acepte monto, cantidad de
personas, propina y modo de redondeo; valide las entradas y muestre la cuota
individual con dos decimales. Se conserva el comportamiento y los seis
escenarios de la spec Flutter. No se incorpora almacenamiento, API ni función
de producto adicional.

## Contexto técnico

- JavaScript con módulos ES y React; Vite sirve la experiencia durante el
  desarrollo y compila los recursos estáticos para producción.
- Estado de la pantalla mediante `useState`; el cálculo se solicita al enviar
  el formulario.
- Las pruebas de dominio usan el runner de Node y las de presentación usan
  Vitest, jsdom y Testing Library según la configuración actual del proyecto.
- `src/main.jsx` compone los servicios e implementaciones concretas usados por
  la aplicación.

## Capas y responsabilidades

- `src/domain/cuenta.js`: valores de la cuenta.
- `src/domain/resultado.js`: cuota por persona.
- `src/domain/estrategiaRedondeo.js`: contrato sustituible `aplicar(valor)`.
- `src/domain/validarEntrada.js`: validación de monto, personas y propina.
- `src/domain/calcularDivision.js`: total con propina, división y delegación
  del redondeo; no valida ni presenta.
- `src/data/redondeoExacto.js` y
  `src/data/redondeoHaciaArriba.js`: estrategias concretas.
- `src/presentation/useDivisor.js`: estado y coordinación del formulario con
  dependencias recibidas.
- `src/presentation/formateadorMoneda.js`: presentación de la cuota con dos
  decimales.
- `src/presentation/CampoEntrada.jsx` y
  `src/presentation/PantallaDivisor.jsx`: controles, errores y resultado.
- `src/main.jsx`: composición de dependencias concretas.

La dirección requerida es `presentation -> domain <- data`. JavaScript no
impone interfaces nominales estáticas: el dominio expresa el contrato como un
objeto con el método acordado y valida el resultado en tiempo de ejecución.

## Flujo

1. La pantalla inicia monto y personas vacíos, propina en 10% y modo exacto.
2. Al enviar, la presentación transforma los textos a números y crea la cuenta.
3. El dominio valida; ante error, la interfaz anuncia el mensaje y elimina un
   resultado previo.
4. Para datos válidos, el dominio calcula
   `monto * (1 + propina / 100) / personas` y delega el redondeo.
5. La interfaz presenta la cuota con dos decimales.

## Validación

- Comparar los seis escenarios de [spec.md](spec.md) con la suite de dominio y
  las pruebas de la pantalla.
- Verificar la sustitución de estrategias y que el dominio no importe React ni
  dependa de la UI.
- Ejecutar `npm test`, `npm run lint` y `npm run build`.
- La suite presente ya implementa el comportamiento, pero debe revisarse frente
  a la estructura exacta de pruebas exigida en la guía (casos parametrizados de
  dominio en Vitest y setup de Testing Library).

## Trazabilidad y límites

Los requerimientos funcionales son los de la spec original. Las decisiones de
React, JavaScript, Vite, módulos y runners de prueba son decisiones de
implementación de este plan; no cambian la semántica del cálculo.
