import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'data/repositories/supabase_auth_repository.dart';
import 'data/repositories/supabase_perfiles_repository.dart';
import 'domain/usecases/registrar_usuario.dart';
import 'presentation/pantallas/login_screen.dart';
import 'presentation/providers/perfiles_provider.dart';
import 'presentation/providers/sesion_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');
  final url = dotenv.env['SUPABASE_URL'];
  final key = dotenv.env['SUPABASE_KEY'];
  if (url == null || key == null || url.isEmpty || key.isEmpty) {
    throw StateError(
      'Completa SUPABASE_URL y SUPABASE_KEY en el archivo .env.',
    );
  }
  await Supabase.initialize(url: url, anonKey: key);

  final authRepo = SupabaseAuthRepository();
  final perfilesRepo = SupabasePerfilesRepository();
  final registrarUsuario = RegistrarUsuario(authRepo, perfilesRepo);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => SesionProvider(authRepo, registrarUsuario),
        ),
        ChangeNotifierProvider(create: (_) => PerfilesProvider(perfilesRepo)),
      ],
      child: const UsuariosApp(),
    ),
  );
}

class UsuariosApp extends StatelessWidget {
  const UsuariosApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'Usuarios USFQ',
    theme: ThemeData(colorScheme: .fromSeed(seedColor: Colors.indigo)),
    home: const LoginScreen(),
  );
}
