import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'data/repositories/supabase_auth_repository.dart';
import 'data/repositories/supabase_perfiles_repository.dart';
import 'domain/usecases/registrar_usuario.dart';
import 'presentation/pantallas/pantalla_ingreso.dart';
import 'presentation/providers/perfiles_provider.dart';
import 'presentation/providers/sesion_provider.dart';

Future<void> main() async {
  // Asegurar que los widgets estén inicializados
  WidgetsFlutterBinding.ensureInitialized();

  // Cargar las variables de entorno desde el archivo .env
  await dotenv.load(fileName: ".env");

  // Inicializar Supabase usando las variables seguras
  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL'] ?? '',
    publishableKey: dotenv.env['SUPABASE_KEY'] ?? '',
  );

  final authRepository = SupabaseAuthRepository();
  final perfilesRepository = SupabasePerfilesRepository();
  final registrarUsuario = RegistrarUsuario(authRepository, perfilesRepository);

  runApp(
    MultiProvider(
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
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Usuarios USFQ',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: const PantallaIngreso(),
    );
  }
}
