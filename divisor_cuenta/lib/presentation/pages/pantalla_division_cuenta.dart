import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../domain/entities/cuenta.dart';
import '../../domain/entities/reparto.dart';
import '../../domain/services/calculadora_reparto.dart';

/// Pantalla para ingresar una cuenta y consultar su reparto.
class PantallaDivisionCuenta extends StatefulWidget {
  const PantallaDivisionCuenta({super.key});

  @override
  State<PantallaDivisionCuenta> createState() => _PantallaDivisionCuentaState();
}

class _PantallaDivisionCuentaState extends State<PantallaDivisionCuenta> {
  final _controladorMonto = TextEditingController();
  final _controladorPersonas = TextEditingController();
  final _calculadora = CalculadoraReparto();

  int _porcentajePropina = 10;
  Reparto? _reparto;
  String? _mensajeError;

  @override
  void dispose() {
    _controladorMonto.dispose();
    _controladorPersonas.dispose();
    super.dispose();
  }

  void _actualizarResultado() {
    final textoMonto = _controladorMonto.text.trim();
    final textoPersonas = _controladorPersonas.text.trim();

    if (textoMonto.isEmpty || textoPersonas.isEmpty) {
      setState(() {
        _reparto = null;
        _mensajeError = 'Ingresa el monto y la cantidad de personas.';
      });
      return;
    }

    final montoCentavos = _leerMontoEnCentavos(textoMonto);
    if (montoCentavos == null) {
      setState(() {
        _reparto = null;
        _mensajeError = 'Ingresa un monto válido con hasta dos decimales.';
      });
      return;
    }

    final cantidadPersonas = int.tryParse(textoPersonas);
    if (cantidadPersonas == null) {
      setState(() {
        _reparto = null;
        _mensajeError = 'Ingresa una cantidad entera de personas.';
      });
      return;
    }

    try {
      final reparto = _calculadora.calcular(
        cuenta: Cuenta(
          montoBaseCentavos: montoCentavos,
          porcentajePropina: _porcentajePropina,
        ),
        cantidadPersonas: cantidadPersonas,
      );
      setState(() {
        _reparto = reparto;
        _mensajeError = null;
      });
    } on ErrorCalculoReparto catch (error) {
      setState(() {
        _reparto = null;
        _mensajeError = error.mensaje;
      });
    }
  }

  int? _leerMontoEnCentavos(String texto) {
    if (!RegExp(r'^-?\d+(?:[.,]\d{0,2})?$').hasMatch(texto)) {
      return null;
    }

    final esNegativo = texto.startsWith('-');
    final montoSinSigno = esNegativo ? texto.substring(1) : texto;
    final partes = montoSinSigno.replaceAll(',', '.').split('.');
    final unidades = int.parse(partes.first);
    final fraccion = partes.length == 1 ? '' : partes[1].padRight(2, '0');
    final centavos =
        unidades * 100 + (fraccion.isEmpty ? 0 : int.parse(fraccion));

    return esNegativo ? -centavos : centavos;
  }

  String _formatearMonto(int centavos) {
    final signo = centavos < 0 ? '-' : '';
    final valorAbsoluto = centavos.abs();
    final unidades = valorAbsoluto ~/ 100;
    final fraccion = (valorAbsoluto % 100).toString().padLeft(2, '0');
    return '$signo$unidades,$fraccion';
  }

  @override
  Widget build(BuildContext context) {
    final colores = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Dividir cuenta')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Text(
              'Comparte la cuenta',
              style: Theme.of(context).textTheme.headlineMedium
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Ingresa el monto y cuántas personas van a pagar.',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 24),
            TextField(
              controller: _controladorMonto,
              onChanged: (_) => _actualizarResultado(),
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[0-9.,-]')),
              ],
              decoration: const InputDecoration(
                labelText: 'Monto de la cuenta',
                hintText: 'Ej. 120,00',
                prefixIcon: Icon(Icons.receipt_long),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _controladorPersonas,
              onChanged: (_) => _actualizarResultado(),
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
                signed: true,
              ),
              decoration: const InputDecoration(
                labelText: 'Cantidad de personas',
                hintText: 'Ej. 3',
                prefixIcon: Icon(Icons.people_outline),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),
            Text('Propina', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: [
                for (final porcentaje in [10, 15, 20])
                  ChoiceChip(
                    label: Text('$porcentaje%'),
                    selected: _porcentajePropina == porcentaje,
                    onSelected: (seleccionado) {
                      if (!seleccionado) return;
                      setState(() => _porcentajePropina = porcentaje);
                      _actualizarResultado();
                    },
                  ),
              ],
            ),
            const SizedBox(height: 24),
            if (_reparto case final reparto?) ...[
              _construirResumen(reparto, colores),
            ] else if (_mensajeError case final mensaje?) ...[
              Text(
                mensaje,
                style: TextStyle(color: colores.error),
                textAlign: TextAlign.center,
              ),
            ] else ...[
              Text(
                'El resultado aparecerá aquí.',
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _construirResumen(Reparto reparto, ColorScheme colores) {
    return Card(
      color: colores.primaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Propina ($_porcentajePropina%)'),
            Text(
              _formatearMonto(reparto.propinaCentavos),
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            Text('Total con propina'),
            Text(
              _formatearMonto(reparto.totalCentavos),
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: colores.onPrimaryContainer,
              ),
            ),
            const Divider(height: 32),
            Text(
              'Pago por persona',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            for (
              var indice = 0;
              indice < reparto.pagosIndividualesCentavos.length;
              indice++
            )
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Persona ${indice + 1}'),
                    Text(
                      _formatearMonto(
                        reparto.pagosIndividualesCentavos[indice],
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
