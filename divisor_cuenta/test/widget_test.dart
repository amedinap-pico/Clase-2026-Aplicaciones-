import 'package:flutter_test/flutter_test.dart';

import 'pantalla_test.dart' as pruebas_pantalla;

void main() {
  testWidgets('la app abre la pantalla del divisor', (tester) async {
    await tester.pumpWidget(pruebas_pantalla.crearAplicacion());
    expect(find.text('Dividir cuenta'), findsOneWidget);
  });
}
