// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:futbol_aplicacion/domain/entities/perfil.dart';
import 'package:futbol_aplicacion/domain/entities/partido_entity.dart';
import 'package:futbol_aplicacion/domain/repositories/auth_repository.dart';
import 'package:futbol_aplicacion/domain/repositories/perfiles_repository.dart';
import 'package:futbol_aplicacion/domain/repositories/partido_repository.dart';
import 'package:futbol_aplicacion/domain/usecases/registrar_usuario.dart';
import 'package:futbol_aplicacion/presentation/pantallas/pantalla_ingreso.dart';
import 'package:futbol_aplicacion/presentation/providers/perfiles_provider.dart';
import 'package:futbol_aplicacion/presentation/providers/partido_provider.dart';
import 'package:futbol_aplicacion/presentation/providers/sesion_provider.dart';
import 'package:futbol_aplicacion/presentation/screens/partidos_screen.dart';

void main() {
  testWidgets('muestra el estado vacío de partidos', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => PartidoProvider(repository: _FakePartidoRepository()),
        child: const MaterialApp(home: PartidosScreen()),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Partidos'), findsOneWidget);
    expect(find.text('Todavía no hay partidos.'), findsOneWidget);
  });

  testWidgets('permite ingresar sin completar el nombre', (
    WidgetTester tester,
  ) async {
    final authRepository = _FakeAuthRepository();
    await tester.pumpWidget(_authApp(authRepository));

    await tester.enterText(find.byType(TextFormField).at(0), 'ana@example.com');
    await tester.enterText(find.byType(TextFormField).at(1), 'clave123');
    await tester.tap(find.text('Ingresar'));
    await tester.pumpAndSettle();

    expect(authRepository.ingresos, 1);
  });

  testWidgets('exige nombre al crear una cuenta', (WidgetTester tester) async {
    final authRepository = _FakeAuthRepository();
    await tester.pumpWidget(_authApp(authRepository));

    await tester.enterText(find.byType(TextFormField).at(0), 'ana@example.com');
    await tester.enterText(find.byType(TextFormField).at(1), 'clave123');
    await tester.tap(find.text('Crear cuenta'));
    await tester.pumpAndSettle();

    expect(find.text('Ingresa tu nombre.'), findsOneWidget);
    expect(authRepository.registros, 0);
  });
}

Widget _authApp(_FakeAuthRepository authRepository) {
  final perfilesRepository = _FakePerfilesRepository();
  final registrarUsuario = RegistrarUsuario(authRepository, perfilesRepository);

  return MultiProvider(
    providers: [
      ChangeNotifierProvider(
        create: (_) => SesionProvider(
          authRepository: authRepository,
          registrarUsuario: registrarUsuario,
        ),
      ),
      ChangeNotifierProvider(
        create: (_) => PerfilesProvider(repository: perfilesRepository),
      ),
    ],
    child: const MaterialApp(home: PantallaIngreso()),
  );
}

class _FakePartidoRepository implements PartidoRepository {
  @override
  Future<List<PartidoEntity>> obtenerPartidos() async => [];
}

class _FakeAuthRepository implements AuthRepository {
  int ingresos = 0;
  int registros = 0;

  @override
  Future<void> ingresar(String correo, String clave) async {
    ingresos++;
  }

  @override
  String? obtenerIdActual() => null;

  @override
  Future<String> registrar(String correo, String clave) async {
    registros++;
    return 'usuario-id';
  }

  @override
  Future<void> salir() async {}
}

class _FakePerfilesRepository implements PerfilesRepository {
  @override
  Future<void> crear(String id, String nombre) async {}

  @override
  Future<List<Perfil>> obtenerTodos() async => [];
}
