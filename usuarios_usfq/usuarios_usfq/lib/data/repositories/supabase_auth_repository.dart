import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/repositories/auth_repository.dart';

class SupabaseAuthRepository implements AuthRepository {
  final SupabaseClient _client = Supabase.instance.client;

  @override
  Future<String> registrar(String correo, String clave) async {
    final response = await _client.auth.signUp(email: correo, password: clave);
    final user = response.user;
    if (user == null) {
      throw const AuthException(
        'No se creó la sesión. Verifica que la confirmación de correo esté desactivada.',
      );
    }
    return user.id;
  }

  @override
  Future<void> ingresar(String correo, String clave) async {
    await _client.auth.signInWithPassword(email: correo, password: clave);
  }

  @override
  Future<void> salir() => _client.auth.signOut();

  @override
  String? obtenerIdActual() => _client.auth.currentUser?.id;
}
