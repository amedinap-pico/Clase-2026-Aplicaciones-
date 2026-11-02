import '../domain/estrategia_redondeo.dart';
import '../domain/resultado.dart';

/// Redondea el pago al centavo más cercano.
class RedondeoExacto implements EstrategiaRedondeo {
  @override
  Resultado redondear(double monto) =>
      Resultado(pagoPorPersona: (monto * 100).round() / 100);
}
