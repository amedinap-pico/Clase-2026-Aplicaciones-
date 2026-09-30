// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:divisor_cuenta/main.dart';

void main() {
  testWidgets('calcula el reparto y actualiza la cantidad de personas', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp());

    await tester.enterText(find.byType(TextField), '10000');
    await tester.pumpAndSettle();
    expect(find.text('\$ 5.500,00'), findsOneWidget);

    await tester.tap(find.byTooltip('Agregar una persona'));
    await tester.pump();

    expect(find.text('3'), findsOneWidget);
    expect(find.text('\$ 3.666,66'), findsOneWidget);
    expect(find.textContaining('primeras 2 personas pagan'), findsOneWidget);
  });
}
