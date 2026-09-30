import 'cuenta.dart';

/// Valida los datos antes de que el caso de uso realice el cálculo.
class ValidarEntrada {
  String? validar(Cuenta cuenta) {
    if (!cuenta.monto.isFinite || cuenta.monto < 0) {
      return 'Monto inválido';
    }
    if (cuenta.personas < 1) {
      return 'Debe haber al menos una persona';
    }
    if (!cuenta.propina.isFinite || cuenta.propina < 0) {
      return 'Propina inválida';
    }
    return null;
  }
}
