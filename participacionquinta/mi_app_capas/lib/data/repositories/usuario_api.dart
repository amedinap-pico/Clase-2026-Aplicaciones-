import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../domain/entities/usuario.dart';
import '../../domain/repositories/usuario_repository.dart';

class UsuarioApi implements UsuarioRepository {
  const UsuarioApi({this._cliente});

  static const _url = 'https://jsonplaceholder.typicode.com/users';
  final http.Client? _cliente;

  @override
  Future<List<Usuario>> obtener() async {
    final respuesta = await (_cliente ?? http.Client()).get(Uri.parse(_url));

    if (respuesta.statusCode != 200) {
      throw Exception('No se pudieron cargar los usuarios');
    }

    final datos = jsonDecode(respuesta.body) as List<dynamic>;

    return datos.map((dato) {
      final json = dato as Map<String, dynamic>;
      return Usuario(
        id: json['id'] as int,
        nombre: json['name'] as String,
        email: json['email'] as String,
      );
    }).toList();
  }
}
