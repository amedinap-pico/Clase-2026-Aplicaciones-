import 'package:flutter/foundation.dart';

import '../../domain/entities/perfil.dart';
import '../../domain/repositories/perfiles_repository.dart';

class PerfilesProvider extends ChangeNotifier {
  PerfilesProvider(this._perfilesRepository);

  final PerfilesRepository _perfilesRepository;
  List<Perfil> perfiles = [];
  bool cargando = false;
  String? error;

  Future<void> cargar() async {
    cargando = true;
    error = null;
    notifyListeners();
    try {
      perfiles = await _perfilesRepository.obtenerTodos();
    } catch (e) {
      error = e.toString().replaceFirst('Exception: ', '');
    } finally {
      cargando = false;
      notifyListeners();
    }
  }
}
