/// Presenta importes con dos decimales, sin decidir reglas de cálculo.
class FormateadorMoneda {
  String formatear(double monto) => monto.toStringAsFixed(2);
}
