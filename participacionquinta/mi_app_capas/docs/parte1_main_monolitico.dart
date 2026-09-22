import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const UsuariosApp());
}

class UsuariosApp extends StatelessWidget {
  const UsuariosApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Usuarios',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: const UsuariosScreen(),
    );
  }
}

class UsuariosScreen extends StatefulWidget {
  const UsuariosScreen({super.key});

  @override
  State<UsuariosScreen> createState() => _UsuariosScreenState();
}

class _UsuariosScreenState extends State<UsuariosScreen> {
  late Future<List<Map<String, dynamic>>> _usuariosFuture;

  @override
  void initState() {
    super.initState();
    _usuariosFuture = _cargarUsuarios();
  }

  Future<List<Map<String, dynamic>>> _cargarUsuarios() async {
    final respuesta = await http.get(
      Uri.parse('https://jsonplaceholder.typicode.com/users'),
    );

    if (respuesta.statusCode != 200) {
      throw Exception('No se pudieron cargar los usuarios');
    }

    final usuarios = jsonDecode(respuesta.body) as List<dynamic>;
    const vocales = 'aeiouáéíóú';

    return usuarios.whereType<Map<String, dynamic>>().where((usuario) {
      final nombre = usuario['name'] as String? ?? '';
      return nombre.isNotEmpty && vocales.contains(nombre[0].toLowerCase());
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Usuarios con nombre vocal')),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _usuariosFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final usuarios = snapshot.data ?? [];
          return ListView.builder(
            itemCount: usuarios.length,
            itemBuilder: (context, index) {
              final usuario = usuarios[index];
              return ListTile(
                leading: CircleAvatar(child: Text('${index + 1}')),
                title: Text(usuario['name'] as String? ?? 'Sin nombre'),
                subtitle: Text(usuario['email'] as String? ?? 'Sin correo'),
              );
            },
          );
        },
      ),
    );
  }
}
