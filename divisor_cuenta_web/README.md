# Deber 2 — Aplicación web: Divisor de cuenta

Aplicación web desarrollada con **React** y **Vite** para calcular cuánto paga
cada persona al dividir una cuenta. La solución organiza sus responsabilidades
en las capas de dominio, estrategias y presentación, siguiendo principios de
arquitectura limpia y SOLID. Las estrategias de redondeo se pueden sustituir a
través de un contrato común, de acuerdo con el principio de sustitución de
Liskov (LSP).

## Requisitos previos

- **Node.js 22.12 o superior**. Vite 8 requiere Node.js 20.19+ o 22.12+, y la
  versión de Vitest usada para las pruebas requiere Node.js 22.12+.
- npm (incluido con Node.js).

> Node.js 18 no es compatible con las versiones actuales de Vite y Vitest de
> este proyecto.

## Instalación y ejecución

1. Clona el repositorio e ingresa a la carpeta del proyecto:

   ```bash
   git clone <URL-del-repositorio>
   cd Clase-2026-Aplicaciones-/divisor_cuenta_web
   ```

   Si ya tienes el repositorio, basta con cambiar al directorio del proyecto:

   ```bash
   cd divisor_cuenta_web
   ```

2. Instala las dependencias:

   ```bash
   npm install
   ```

3. Inicia el servidor de desarrollo:

   ```bash
   npm run dev
   ```

4. Abre en el navegador la dirección local que muestra Vite, normalmente
   `http://localhost:5173`.

## Pruebas Automatizadas y Calidad

Ejecuta los comandos desde la carpeta `divisor_cuenta_web`, después de instalar
las dependencias con `npm install`.

### Pruebas automatizadas

El comando habitual ejecuta ambas suites en secuencia:

```bash
npm test
```

1. **Dominio:** `node --test test/domain.test.js` ejecuta los casos de cálculo,
   validación y sustitución de estrategias (LSP) con el runner integrado de
   Node.js.
2. **Interfaz:** si la suite de dominio pasa, el script ejecuta `vitest run`.
   Vitest usa jsdom y Testing Library para verificar los valores iniciales,
   los seis escenarios de aceptación, los mensajes de error, la accesibilidad
   de los campos y las interacciones con el formulario.

Si una suite falla, `npm test` termina con error y muestra la salida del runner
que detectó el problema.

### Análisis estático y compilación

```bash
npm run lint
npm run build
```

- `npm run lint` ejecuta Oxlint para detectar problemas estáticos en el código.
- `npm run build` compila la aplicación para producción y genera los archivos
  en `dist/`. Un error de compilación hace que el comando termine con estado
  distinto de cero.

Para previsualizar el build localmente:

```bash
npm run preview
```

## Requerimientos funcionales

- Una sola pantalla permite ingresar monto, número de personas y porcentaje de
  propina, elegir el modo de redondeo y activar **Calcular**. El cálculo ocurre
  al enviar el formulario, no mientras se editan los campos.
- La propina inicial es 10% y se permite ingresar 0%. El modo inicial es
  **Exacto**.
- El cálculo sigue este orden: `monto * (1 + propina / 100)`, división del total
  entre las personas y aplicación del redondeo a la cuota individual.
- **Exacto** redondea la cuota al centavo más cercano. **Hacia arriba** la
  redondea al siguiente entero monetario; si ya es entero, permanece igual.
- El resultado se muestra como pago por persona con exactamente dos decimales.
- Cada persona paga la misma cuota calculada. No se redistribuyen residuos ni
  se ajusta el último pago para conservar el total. Por ejemplo, 10.00 entre 3
  personas con redondeo hacia arriba produce 4.00 por persona, es decir, 12.00
  si las tres pagan esa cuota.
- El monto y la propina deben ser numéricos, finitos y no negativos. El número
  de personas debe ser un entero mayor o igual a uno.
- Si una entrada es inválida, se muestra el error correspondiente y no se
  muestra ningún resultado:
  - monto inválido: `Monto inválido`
  - personas menor que uno o no entero: `Debe haber al menos una persona`
  - propina inválida: `Propina inválida`

## Escenarios de aceptación

1. Monto 100.00, 4 personas, propina 10% y modo exacto: resultado `27.50`.
2. Monto 90.00, 3 personas, propina 0% y modo exacto: resultado `30.00`.
3. Monto 50.00, 0 personas y propina 0%: mensaje `Debe haber al menos una
   persona` y ningún resultado.
4. Monto no numérico: mensaje `Monto inválido`.
5. Monto 10.00, 3 personas, propina 0% y modo exacto: resultado `3.33`.
6. Los mismos datos del caso 5 con modo hacia arriba: resultado `4.00`.

## Calidad y límites del alcance

- La aplicación funciona sin conexión y no guarda los datos ingresados.
- La pantalla debe funcionar en móvil y escritorio; los campos, selector,
  acción, mensajes y resultado deben permanecer utilizables.
- Todo el contenido visible y los mensajes están en español, y los errores
  están asociados a sus campos y se anuncian de forma accesible.
- El alcance se limita a dividir una cuenta con cuota igual. No incluye pagos
  distintos por persona, historial, inicio de sesión, persistencia ni API.
- No se agregan dependencias para la funcionalidad del producto. Las
  dependencias de desarrollo de Vitest y Testing Library se usan para las
  pruebas automatizadas de interfaz solicitadas.

## Arquitectura del proyecto

```text
src/
  domain/        # Cuenta, resultado, validación, cálculo y contrato
  data/          # Implementaciones de estrategias de redondeo
  presentation/  # Pantalla, campos reutilizables y hook de interacción
  App.jsx        # Composición principal
  main.jsx       # Composición de dependencias y punto de entrada
test/
  domain.test.js   # Pruebas de reglas de dominio y estrategias
  pantalla.test.jsx # Pruebas de interfaz e interacciones
specs/
  001-dividir-cuenta/
    requirements.md # Requerimientos funcionales y aceptación
    analysis.md     # Separación entre QUÉ y CÓMO
    tasks.md        # Tareas del Deber 2
```

La dirección de dependencias es **Presentación → Dominio ← Datos/Estrategias**:

- `domain/` contiene los modelos, la validación, el caso de uso del cálculo y
  el contrato de redondeo. No depende de React, del DOM ni de la presentación.
- `data/` contiene las implementaciones concretas de las estrategias; no es una
  base de datos ni requiere acceso remoto para este proyecto.
- `presentation/` contiene la pantalla, los campos y el hook que coordina la
  interacción con los servicios del dominio.
- `main.jsx` compone el cálculo, el validador y las estrategias concretas, y los
  inyecta en la presentación. El caso de uso trabaja con el contrato y no
  inspecciona los tipos concretos de estrategia, lo que permite sustituirlas
  (LSP).
