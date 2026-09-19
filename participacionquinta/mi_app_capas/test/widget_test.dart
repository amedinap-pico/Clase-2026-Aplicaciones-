// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';

import 'package:mi_app_capas/data/repositories/usuario_api.dart';
import 'package:mi_app_capas/domain/usecases/obtener_usuarios_con_vocal.dart';
import 'package:mi_app_capas/main.dart';

void main() {
  testWidgets('muestra la pantalla de usuarios', (WidgetTester tester) async {
    await tester.pumpWidget(
      const UsuariosApp(
        obtenerUsuariosConVocal: ObtenerUsuariosConVocal(UsuarioApi()),
      ),
    );

    expect(find.text('Usuarios con nombre vocal'), findsOneWidget);
  });
}
