import 'package:flutter/foundation.dart';

import '../../domain/repositories/auth_repository.dart';
import '../../domain/usecases/registrar_usuario.dart';

class SesionProvider extends ChangeNotifier {
  SesionProvider(this._authRepository, this._registrarUsuario)
      : idUsuario = _authRepository.obtenerIdActual();

  final AuthRepository _authRepository;
  final RegistrarUsuario _registrarUsuario;

  String? idUsuario;
  bool cargando = false;
  String? error;

  Future<void> registrar(String correo, String clave, String nombre) async {
    _iniciar();
    try {
      await _registrarUsuario(correo, clave, nombre);
      idUsuario = _authRepository.obtenerIdActual();
    } catch (e) {
      error = _mensaje(e);
    } finally {
      _terminar();
    }
  }

  Future<void> ingresar(String correo, String clave) async {
    _iniciar();
    try {
      await _authRepository.ingresar(correo, clave);
      idUsuario = _authRepository.obtenerIdActual();
    } catch (e) {
      error = _mensaje(e);
    } finally {
      _terminar();
    }
  }

  Future<void> salir() async {
    _iniciar();
    try {
      await _authRepository.salir();
      idUsuario = null;
    } catch (e) {
      error = _mensaje(e);
    } finally {
      _terminar();
    }
  }

  void _iniciar() {
    cargando = true;
    error = null;
    notifyListeners();
  }

  void _terminar() {
    cargando = false;
    notifyListeners();
  }

  String _mensaje(Object e) => e.toString().replaceFirst('Exception: ', '');
}
