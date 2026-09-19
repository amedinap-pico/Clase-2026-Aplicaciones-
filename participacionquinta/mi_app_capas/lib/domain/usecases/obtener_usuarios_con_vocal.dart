import '../entities/usuario.dart';
import '../repositories/usuario_repository.dart';

class ObtenerUsuariosConVocal {
  const ObtenerUsuariosConVocal(this._repositorio);

  final UsuarioRepository _repositorio;

  Future<List<Usuario>> call() async {
    final usuarios = await _repositorio.obtenerUsuarios();
    const vocales = 'aeiouáéíóú';

    return usuarios.where((usuario) {
      final nombre = usuario.name.trim().toLowerCase();
      return nombre.isNotEmpty && vocales.contains(nombre[0]);
    }).toList();
  }
}
