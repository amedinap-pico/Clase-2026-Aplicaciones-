import 'package:flutter/material.dart';

import '../domain/cuenta.dart';
import 'divisor_controller.dart';
import 'formateador_moneda.dart';

/// Pantalla única para ingresar una cuenta y consultar el pago individual.
class PantallaDivisor extends StatefulWidget {
  const PantallaDivisor({required this.controller, super.key});

  final DivisorController controller;

  @override
  State<PantallaDivisor> createState() => _PantallaDivisorState();
}

class _PantallaDivisorState extends State<PantallaDivisor> {
  final _monto = TextEditingController();
  final _personas = TextEditingController();
  final _propina = TextEditingController(text: '10');
  final _formateador = FormateadorMoneda();
  bool _haciaArriba = false;
  String? _error;
  double? _pago;

  @override
  void dispose() {
    _monto.dispose();
    _personas.dispose();
    _propina.dispose();
    super.dispose();
  }

  void _calcular() {
    final monto = double.tryParse(_monto.text.trim()) ?? double.nan;
    final personas = int.tryParse(_personas.text.trim()) ?? 0;
    final propina = double.tryParse(_propina.text.trim()) ?? double.nan;
    final cuenta = Cuenta(monto: monto, personas: personas, propina: propina);
    final error = widget.controller.validar(cuenta);

    if (error != null) {
      setState(() {
        _error = error;
        _pago = null;
      });
      return;
    }

    final resultado = widget.controller.calcular(
      cuenta,
      haciaArriba: _haciaArriba,
    );
    setState(() {
      _error = null;
      _pago = resultado.pagoPorPersona;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dividir cuenta')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          TextField(
            controller: _monto,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(
              labelText: 'Monto total',
              hintText: 'Ej. 100.00',
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _personas,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'Número de personas'),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _propina,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(labelText: 'Propina (%)'),
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<bool>(
            initialValue: _haciaArriba,
            decoration: const InputDecoration(labelText: 'Modo de redondeo'),
            items: const [
              DropdownMenuItem(value: false, child: Text('Exacto')),
              DropdownMenuItem(value: true, child: Text('Hacia arriba')),
            ],
            onChanged: (valor) {
              if (valor != null) setState(() => _haciaArriba = valor);
            },
          ),
          const SizedBox(height: 20),
          FilledButton(onPressed: _calcular, child: const Text('Calcular')),
          if (_error != null) ...[
            const SizedBox(height: 16),
            Text(_error!, key: const Key('mensaje-error')),
          ],
          if (_pago case final pago?) ...[
            const SizedBox(height: 20),
            Text('Pago por persona: ${_formateador.formatear(pago)}'),
          ],
        ],
      ),
    );
  }
}
