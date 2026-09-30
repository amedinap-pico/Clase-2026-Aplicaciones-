import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:divisor_cuenta/main.dart';

void main() {
  testWidgets('calcula el reparto y actualiza la propina seleccionada', (
    tester,
  ) async {
    await tester.pumpWidget(const AplicacionDivisorCuenta());

    expect(find.text('Dividir cuenta'), findsOneWidget);
    expect(find.text('10%'), findsOneWidget);

    await tester.enterText(find.byType(TextField).at(0), '120');
    await tester.enterText(find.byType(TextField).at(1), '3');
    await tester.pumpAndSettle();

    expect(find.text('132,00'), findsOneWidget);
    expect(find.text('44,00'), findsNWidgets(3));

    await tester.tap(find.text('15%'));
    await tester.pumpAndSettle();

    expect(find.text('Propina (15%)'), findsOneWidget);
    expect(find.text('138,00'), findsOneWidget);
    expect(find.text('46,00'), findsNWidgets(3));

    await tester.tap(find.text('20%'));
    await tester.pumpAndSettle();

    expect(find.text('Propina (20%)'), findsOneWidget);
    expect(find.text('144,00'), findsOneWidget);
    expect(find.text('48,00'), findsNWidgets(3));
  });

  testWidgets('muestra un mensaje y oculta el reparto para un dato inválido', (
    tester,
  ) async {
    await tester.pumpWidget(const AplicacionDivisorCuenta());

    await tester.enterText(find.byType(TextField).at(0), '-5');
    await tester.enterText(find.byType(TextField).at(1), '2');
    await tester.pumpAndSettle();

    expect(
      find.text('El monto de la cuenta no puede ser negativo.'),
      findsOneWidget,
    );
    expect(find.text('Total con propina'), findsNothing);
  });

  testWidgets('distribuye los centavos residuales sin perder el total', (
    tester,
  ) async {
    await tester.pumpWidget(const AplicacionDivisorCuenta());

    await tester.enterText(find.byType(TextField).at(0), '10');
    await tester.enterText(find.byType(TextField).at(1), '3');
    await tester.pumpAndSettle();

    expect(find.text('11,00'), findsOneWidget);
    expect(find.text('3,67'), findsNWidgets(2));
    expect(find.text('3,66'), findsOneWidget);
  });
}
