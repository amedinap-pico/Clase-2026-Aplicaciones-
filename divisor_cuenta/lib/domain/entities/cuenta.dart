/// Datos de entrada de una cuenta expresados en centavos.
class Cuenta {
  const Cuenta({
    required this.montoBaseCentavos,
    required this.porcentajePropina,
  });

  /// Monto antes de agregar la propina.
  final int montoBaseCentavos;

  /// Porcentaje de propina seleccionado: 10, 15 o 20.
  final int porcentajePropina;
}
