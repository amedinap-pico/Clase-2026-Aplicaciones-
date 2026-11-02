# Análisis: División de cuenta web

**Parte 2 del Deber 2 — separar el QUÉ del CÓMO**

## QUÉ: necesidad y comportamiento

La aplicación ayuda a calcular la cuota de una cuenta compartida. La persona
ingresa el monto, la cantidad de personas y la propina, elige cómo redondear y
solicita el cálculo. Debe recibir la cuota individual o un mensaje de
validación, según corresponda.

El QUÉ normativo está detallado en
[requirements.md](requirements.md): ahí se definen entradas, reglas observables,
mensajes, límites y los seis escenarios de aceptación. La especificación
Flutter original es la fuente; por tanto, esta migración conserva que:

- se incorpora la propina antes de dividir;
- el redondeo se aplica a la cuota individual;
- exacto significa redondear al centavo más cercano;
- hacia arriba significa redondear al entero monetario siguiente;
- no se reparten residuos ni se fuerza la conservación del total.

## CÓMO: propuesta de solución web

### Plataforma y organización

- Usar el proyecto React + Vite ya inicializado en JavaScript.
- Mantener una pantalla y separar responsabilidades por capas:
  - `src/presentation/`: formulario, estado de la pantalla, mensajes y resultado;
  - `src/domain/`: modelo de entrada, validación y caso de uso de cálculo;
  - `src/data/`: implementaciones concretas de las estrategias de redondeo,
    siguiendo la arquitectura de la aplicación Flutter de referencia.
- La presentación conoce el dominio; el dominio define el contrato que reciben
  sus estrategias; las implementaciones concretas satisfacen ese contrato. El
  cálculo no debe inspeccionar tipos concretos de estrategia ni depender de
  React o del DOM.
- `src/data/` no representa una base de datos: no se necesita almacenamiento ni
  una fuente remota para este alcance.

### Flujo propuesto

1. La pantalla inicializa monto y personas vacíos, propina en `10` y redondeo
   exacto seleccionado.
2. Al activar **Calcular**, la presentación convierte las entradas y entrega
   sus valores al dominio.
3. El dominio valida monto, personas y propina antes de ejecutar el cálculo.
4. Si la validación falla, la pantalla muestra el mensaje correspondiente y
   limpia u oculta el resultado anterior.
5. Si es válida, el dominio calcula `monto * (1 + propina / 100)`, divide entre
   personas y delega el redondeo a la estrategia seleccionada.
6. La presentación muestra la cuota con dos decimales.

### Interfaz y calidad

- Usar controles HTML apropiados para monto, cantidad, propina y selección;
  asociar etiquetas a los campos y hacer perceptibles los errores para
  tecnologías de asistencia.
- Mantener el orden de interacción: entradas, selector, acción, después
  mensaje o resultado.
- Adaptar el diseño a móvil y escritorio sin ocultar información funcional.
- Mantener el funcionamiento local; no introducir persistencia, API ni
  dependencias nuevas para resolver este alcance.

### Verificación propuesta

- Cubrir los seis escenarios de aceptación con verificaciones de cálculo y
  validación.
- Comprobar el flujo de presentación para cálculo válido e inválido, incluyendo
  que un error no deje visible un resultado previo.
- Revisar que el dominio no importe React ni dependa de la presentación.
- Ejecutar `npm run lint` y `npm run build`; agregar verificación automatizada
  del dominio/UI como tarea de implementación, respetando el límite de no
  agregar dependencias sin autorización.

## Fuera del análisis

No se definen aquí funciones adicionales ni decisiones no confirmadas sobre
moneda, localización numérica regional o reparto desigual. Si se requieren,
deben actualizarse primero los requerimientos y escenarios de aceptación.
