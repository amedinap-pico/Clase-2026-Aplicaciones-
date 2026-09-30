import 'package:flutter/material.dart';

import 'presentation/pages/pantalla_division_cuenta.dart';

void main() {
  runApp(const AplicacionDivisorCuenta());
}

class AplicacionDivisorCuenta extends StatelessWidget {
  const AplicacionDivisorCuenta({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dividir cuenta',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      home: const PantallaDivisionCuenta(),
    );
  }
}
