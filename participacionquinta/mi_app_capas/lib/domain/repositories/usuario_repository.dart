import '../entities/usuario.dart';

abstract interface class UsuarioRepository {
  Future<List<Usuario>> obtenerUsuarios();
}
