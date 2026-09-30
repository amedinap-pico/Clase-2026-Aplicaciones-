import 'package:flutter_test/flutter_test.dart';
import 'package:divisor_cuenta/data/redondeo_exacto.dart';
import 'package:divisor_cuenta/data/redondeo_hacia_arriba.dart';
import 'package:divisor_cuenta/domain/calcular_division.dart';
import 'package:divisor_cuenta/domain/cuenta.dart';
import 'package:divisor_cuenta/domain/estrategia_redondeo.dart';
import 'package:divisor_cuenta/domain/validar_entrada.dart';

import 'casos_de_prueba.dart';

void main() {
  final validarEntrada = ValidarEntrada();
  final calcularDivision = CalcularDivision();
  final redondeoExacto = RedondeoExacto();
  final redondeoHaciaArriba = RedondeoHaciaArriba();

  for (final caso in casos) {
    test(caso.nombre, () {
      final cuenta = Cuenta(
        monto: caso.monto,
        personas: caso.personas,
        propina: caso.propina,
      );
      final error = validarEntrada.validar(cuenta);

      if (caso.errorEsperado != null) {
        expect(error, caso.errorEsperado);
        return; // Si la validación falla, no se ejecuta el cálculo.
      }

      expect(error, isNull);
      final EstrategiaRedondeo estrategia = caso.modo == 'arriba'
          ? redondeoHaciaArriba
          : redondeoExacto;
      final resultado = calcularDivision.calcular(cuenta, estrategia);
      expect(resultado.pagoPorPersona, closeTo(caso.esperado!, 0.001));
    });
  }

  test('LSP: el caso de uso acepta cualquiera de las dos estrategias', () {
    const cuenta = Cuenta(monto: 10, personas: 3, propina: 0);
    expect(
      calcularDivision.calcular(cuenta, redondeoExacto).pagoPorPersona,
      closeTo(3.33, 0.001),
    );
    expect(
      calcularDivision.calcular(cuenta, redondeoHaciaArriba).pagoPorPersona,
      closeTo(4, 0.001),
    );
  });
}
