import '../entities/cuenta.dart';
import '../entities/reparto.dart';

/// Tipos de datos inválidos que la capa de presentación puede comunicar.
enum TipoErrorCalculoReparto {
  montoNegativo,
  porcentajePropinaNoPermitido,
  cantidadPersonasNoPositiva,
}

/// Error de dominio con un tipo estable y un mensaje legible.
class ErrorCalculoReparto implements Exception {
  const ErrorCalculoReparto(this.tipo);

  final TipoErrorCalculoReparto tipo;

  String get mensaje => switch (tipo) {
    TipoErrorCalculoReparto.montoNegativo =>
      'El monto de la cuenta no puede ser negativo.',
    TipoErrorCalculoReparto.porcentajePropinaNoPermitido =>
      'La propina debe ser del 10%, 15% o 20%.',
    TipoErrorCalculoReparto.cantidadPersonasNoPositiva =>
      'La cantidad de personas debe ser un entero positivo.',
  };

  @override
  String toString() => mensaje;
}

/// Calcula la propina, el total y los pagos individuales de una cuenta.
///
/// Esta clase pertenece al dominio y no depende de Flutter.
class CalculadoraReparto {
  static const Set<int> porcentajesPropinaPermitidos = {10, 15, 20};

  Reparto calcular({required Cuenta cuenta, required int cantidadPersonas}) {
    _validar(cuenta: cuenta, cantidadPersonas: cantidadPersonas);

    final propinaCentavos = _redondearPorcentaje(
      cuenta.montoBaseCentavos,
      cuenta.porcentajePropina,
    );
    final totalCentavos = cuenta.montoBaseCentavos + propinaCentavos;
    final pagoBaseCentavos = totalCentavos ~/ cantidadPersonas;
    final centavosResiduales = totalCentavos % cantidadPersonas;

    // Los primeros pagos reciben un centavo adicional hasta agotar el residuo.
    final pagos = List<int>.generate(
      cantidadPersonas,
      (indice) => pagoBaseCentavos + (indice < centavosResiduales ? 1 : 0),
      growable: false,
    );

    return Reparto(
      cantidadPersonas: cantidadPersonas,
      propinaCentavos: propinaCentavos,
      totalCentavos: totalCentavos,
      pagosIndividualesCentavos: pagos,
    );
  }

  void _validar({required Cuenta cuenta, required int cantidadPersonas}) {
    if (cuenta.montoBaseCentavos < 0) {
      throw const ErrorCalculoReparto(TipoErrorCalculoReparto.montoNegativo);
    }

    if (!porcentajesPropinaPermitidos.contains(cuenta.porcentajePropina)) {
      throw const ErrorCalculoReparto(
        TipoErrorCalculoReparto.porcentajePropinaNoPermitido,
      );
    }

    if (cantidadPersonas < 1) {
      throw const ErrorCalculoReparto(
        TipoErrorCalculoReparto.cantidadPersonasNoPositiva,
      );
    }
  }

  /// Redondea la propina al centavo más cercano, con los medios centavos
  /// redondeados hacia arriba.
  int _redondearPorcentaje(int montoCentavos, int porcentaje) {
    return (montoCentavos * porcentaje + 50) ~/ 100;
  }
}
