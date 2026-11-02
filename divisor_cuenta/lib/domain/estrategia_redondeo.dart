import 'resultado.dart';

/// Contrato mínimo para aplicar una política de redondeo al pago individual.
abstract interface class EstrategiaRedondeo {
  Resultado redondear(double monto);
}
