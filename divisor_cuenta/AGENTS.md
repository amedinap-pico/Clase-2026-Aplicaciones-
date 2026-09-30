# Instrucciones del proyecto

## Descripción
App Flutter de una sola pantalla para dividir una cuenta entre varias personas.

## Estructura y dependencias
- Organiza el código en `lib/presentation`, `lib/domain` y `lib/data`.
- Mantén la dirección de dependencias `presentation -> domain <- data`.
- `domain` no debe importar nada de `package:flutter`.

## Estándares
- Usa null safety.
- Escribe nombres de clases, variables y métodos en español.
- No agregues paquetes externos.

## Límites
- No modifiques `test/` salvo que el usuario lo pida.
- No agregues dependencias a `pubspec.yaml` sin avisar al usuario.
- No modifiques `android/` ni `ios/`.

## Comandos
- `flutter pub get`
- `flutter run`
- `flutter analyze`
- `flutter test`