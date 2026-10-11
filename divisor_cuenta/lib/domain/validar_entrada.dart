import 'cuenta.dart';

/// Valida los datos antes de que el caso de uso realice el cálculo.
class ValidarEntrada {
  static const double _porcentajeMaximoPropina = 100;

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
    if (cuenta.propina > _porcentajeMaximoPropina) {
      return 'La propina no puede superar el 100%';
    }
    return null;
  }
}
