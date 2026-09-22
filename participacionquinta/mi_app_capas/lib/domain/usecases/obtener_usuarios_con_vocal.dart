import '../entities/usuario.dart';
import '../repositories/usuario_repository.dart';

class ObtenerUsuariosConVocal {
  const ObtenerUsuariosConVocal(this._repositorio);

  final UsuarioRepository _repositorio;

  Future<List<Usuario>> call() async {
    final usuarios = await _repositorio.obtener();
    const vocales = 'aeiou';

    return usuarios.where((usuario) {
      final nombre = usuario.nombre.trim().toLowerCase();
      return nombre.isNotEmpty && vocales.contains(nombre[0]);
    }).toList();
  }
}
