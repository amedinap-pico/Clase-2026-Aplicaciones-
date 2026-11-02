import 'package:flutter/material.dart';

import 'data/redondeo_exacto.dart';
import 'data/redondeo_hacia_arriba.dart';
import 'domain/calcular_division.dart';
import 'domain/validar_entrada.dart';
import 'presentation/divisor_controller.dart';
import 'presentation/pantalla_divisor.dart';

void main() {
  final controller = DivisorController(
    calcularDivision: CalcularDivision(),
    validarEntrada: ValidarEntrada(),
    redondeoExacto: RedondeoExacto(),
    redondeoHaciaArriba: RedondeoHaciaArriba(),
  );
  runApp(AplicacionDivisorCuenta(controller: controller));
}

class AplicacionDivisorCuenta extends StatelessWidget {
  const AplicacionDivisorCuenta({required this.controller, super.key});

  final DivisorController controller;

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'Dividir cuenta',
    theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal)),
    home: PantallaDivisor(controller: controller),
  );
}
