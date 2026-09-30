/// Resultado monetario de dividir una cuenta entre varias personas.
class Reparto {
  Reparto({
    required this.cantidadPersonas,
    required this.propinaCentavos,
    required this.totalCentavos,
    required List<int> pagosIndividualesCentavos,
  }) : pagosIndividualesCentavos =
           List<int>.unmodifiable(pagosIndividualesCentavos);

  final int cantidadPersonas;
  final int propinaCentavos;
  final int totalCentavos;

  /// Pagos expresados en centavos. Su suma equivale a [totalCentavos].
  ///
  /// Algunos pagos pueden diferir en un centavo cuando el total no se divide
  /// exactamente entre las personas.
  final List<int> pagosIndividualesCentavos;
}
