import 'cuenta.dart';
import 'estrategia_redondeo.dart';
import 'resultado.dart';

/// Caso de uso que calcula el pago individual y delega el redondeo.
class CalcularDivision {
  Resultado calcular(Cuenta cuenta, EstrategiaRedondeo estrategia) {
    final total = cuenta.monto * (1 + cuenta.propina / 100);
    final pagoSinRedondear = total / cuenta.personas;
    return estrategia.redondear(pagoSinRedondear);
  }
}
