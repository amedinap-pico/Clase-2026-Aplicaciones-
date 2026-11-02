import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:divisor_cuenta/data/redondeo_exacto.dart';
import 'package:divisor_cuenta/data/redondeo_hacia_arriba.dart';
import 'package:divisor_cuenta/domain/calcular_division.dart';
import 'package:divisor_cuenta/domain/validar_entrada.dart';
import 'package:divisor_cuenta/main.dart';
import 'package:divisor_cuenta/presentation/divisor_controller.dart';

AplicacionDivisorCuenta crearAplicacion() {
  return AplicacionDivisorCuenta(
    controller: DivisorController(
      calcularDivision: CalcularDivision(),
      validarEntrada: ValidarEntrada(),
      redondeoExacto: RedondeoExacto(),
      redondeoHaciaArriba: RedondeoHaciaArriba(),
    ),
  );
}

void main() {
  testWidgets('calcula el pago individual en modo exacto', (tester) async {
    await tester.pumpWidget(crearAplicacion());
    await tester.enterText(find.byType(TextField).at(0), '100');
    await tester.enterText(find.byType(TextField).at(1), '4');
    await tester.enterText(find.byType(TextField).at(2), '10');
    await tester.tap(find.text('Calcular'));
    await tester.pumpAndSettle();

    expect(find.text('Pago por persona: 27.50'), findsOneWidget);
  });

  testWidgets('informa que debe haber una persona y oculta el resultado', (
    tester,
  ) async {
    await tester.pumpWidget(crearAplicacion());
    await tester.enterText(find.byType(TextField).at(0), '50');
    await tester.enterText(find.byType(TextField).at(1), '0');
    await tester.enterText(find.byType(TextField).at(2), '0');
    await tester.tap(find.text('Calcular'));
    await tester.pumpAndSettle();

    expect(find.text('Debe haber al menos una persona'), findsOneWidget);
    expect(find.textContaining('Pago por persona:'), findsNothing);
  });

  testWidgets('informa cuando el monto no es numérico', (tester) async {
    await tester.pumpWidget(crearAplicacion());
    await tester.enterText(find.byType(TextField).at(0), 'abc');
    await tester.enterText(find.byType(TextField).at(1), '4');
    await tester.enterText(find.byType(TextField).at(2), '0');
    await tester.tap(find.text('Calcular'));
    await tester.pumpAndSettle();

    expect(find.text('Monto inválido'), findsOneWidget);
  });
}
