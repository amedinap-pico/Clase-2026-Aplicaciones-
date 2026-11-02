import '../domain/calcular_division.dart';
import '../domain/cuenta.dart';
import '../domain/estrategia_redondeo.dart';
import '../domain/resultado.dart';
import '../domain/validar_entrada.dart';

/// Coordina validación y cálculo para la pantalla.
class DivisorController {
  DivisorController({
    required this.calcularDivision,
    required this.validarEntrada,
    required this.redondeoExacto,
    required this.redondeoHaciaArriba,
  });

  final CalcularDivision calcularDivision;
  final ValidarEntrada validarEntrada;
  final EstrategiaRedondeo redondeoExacto;
  final EstrategiaRedondeo redondeoHaciaArriba;

  String? validar(Cuenta cuenta) => validarEntrada.validar(cuenta);

  Resultado calcular(Cuenta cuenta, {required bool haciaArriba}) {
    final estrategia = haciaArriba ? redondeoHaciaArriba : redondeoExacto;
    return calcularDivision.calcular(cuenta, estrategia);
  }
}
