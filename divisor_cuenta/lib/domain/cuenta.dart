/// Datos ingresados para dividir una cuenta.
class Cuenta {
  const Cuenta({
    required this.monto,
    required this.personas,
    required this.propina,
  });

  /// Monto antes de propina, expresado en unidades monetarias.
  final double monto;
  final int personas;

  /// Porcentaje de propina; se admite cero.
  final double propina;
}
