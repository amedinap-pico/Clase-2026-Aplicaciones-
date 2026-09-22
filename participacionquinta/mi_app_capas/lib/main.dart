import 'package:flutter/material.dart';

import 'data/repositories/usuario_memoria.dart';
import 'domain/usecases/obtener_usuarios_con_vocal.dart';
import 'presentation/screens/usuarios_screen.dart';

void main() {
  const usuarioMemoria = UsuarioMemoria();
  final obtenerUsuariosConVocal = ObtenerUsuariosConVocal(usuarioMemoria);

  runApp(UsuariosApp(obtenerUsuariosConVocal: obtenerUsuariosConVocal));
}

class UsuariosApp extends StatelessWidget {
  const UsuariosApp({required this.obtenerUsuariosConVocal, super.key});

  final ObtenerUsuariosConVocal obtenerUsuariosConVocal;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Usuarios',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: UsuariosScreen(obtenerUsuariosConVocal: obtenerUsuariosConVocal),
    );
  }
}
