import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../domain/entities/usuario.dart';
import '../../domain/repositories/usuario_repository.dart';

class UsuarioApi implements UsuarioRepository {
  const UsuarioApi({this._cliente});

  static const _url = 'https://jsonplaceholder.typicode.com/users';
  final http.Client? _cliente;

  @override
  Future<List<Usuario>> obtenerUsuarios() async {
    final respuesta = await (_cliente ?? http.Client()).get(Uri.parse(_url));

    if (respuesta.statusCode != 200) {
      throw Exception('No se pudieron cargar los usuarios');
    }

    final datos = jsonDecode(respuesta.body) as List<dynamic>;

    return datos.map((dato) {
      final json = dato as Map<String, dynamic>;
      final direccion = json['address'] as Map<String, dynamic>;

      return Usuario(
        id: json['id'] as int,
        name: json['name'] as String,
        username: json['username'] as String,
        email: json['email'] as String,
        phone: json['phone'] as String,
        website: json['website'] as String,
        street: direccion['street'] as String,
        city: direccion['city'] as String,
      );
    }).toList();
  }
}
