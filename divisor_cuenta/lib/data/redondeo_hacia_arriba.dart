import '../domain/estrategia_redondeo.dart';
import '../domain/resultado.dart';

/// Redondea el pago hacia arriba al siguiente entero monetario.
class RedondeoHaciaArriba implements EstrategiaRedondeo {
  @override
  Resultado redondear(double monto) =>
      Resultado(pagoPorPersona: monto.ceilToDouble());
}
