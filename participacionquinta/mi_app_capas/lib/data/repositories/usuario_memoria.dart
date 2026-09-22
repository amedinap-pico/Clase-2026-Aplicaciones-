import '../../domain/entities/usuario.dart';
import '../../domain/repositories/usuario_repository.dart';

class UsuarioMemoria implements UsuarioRepository {
  const UsuarioMemoria();

  @override
  Future<List<Usuario>> obtener() async {
    return const [
      Usuario(id: 1, nombre: 'Ana García', email: 'ana.garcia@example.com'),
      Usuario(id: 2, nombre: 'Bruno López', email: 'bruno.lopez@example.com'),
      Usuario(id: 3, nombre: 'Elena Torres', email: 'elena.torres@example.com'),
    ];
  }
}
