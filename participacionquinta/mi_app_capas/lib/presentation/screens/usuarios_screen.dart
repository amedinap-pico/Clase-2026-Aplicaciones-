import 'package:flutter/material.dart';

import '../../domain/entities/usuario.dart';
import '../../domain/usecases/obtener_usuarios_con_vocal.dart';

class UsuariosScreen extends StatelessWidget {
  const UsuariosScreen({required this.obtenerUsuariosConVocal, super.key});

  final ObtenerUsuariosConVocal obtenerUsuariosConVocal;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Usuarios con nombre vocal')),
      body: FutureBuilder<List<Usuario>>(
        future: obtenerUsuariosConVocal(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  'Ocurrió un error al cargar los usuarios:\n${snapshot.error}',
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          final usuarios = snapshot.data ?? [];

          if (usuarios.isEmpty) {
            return const Center(child: Text('No hay usuarios para mostrar.'));
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: usuarios.length,
            separatorBuilder: (_, index) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final usuario = usuarios[index];

              return Card(
                child: ListTile(
                  leading: CircleAvatar(child: Text('${usuario.id}')),
                  title: Text(usuario.name),
                  subtitle: Text(
                    '${usuario.email}\n'
                    '${usuario.city}, ${usuario.street}',
                  ),
                  isThreeLine: true,
                ),
              );
            },
          );
        },
      ),
    );
  }
}
