import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cuenta Clara',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF5F5F0),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF176B52),
          surface: const Color(0xFFF5F5F0),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFF5F5F0),
          foregroundColor: Color(0xFF18231E),
          surfaceTintColor: Colors.transparent,
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFE1E5DF)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFE1E5DF)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFF176B52), width: 1.5),
          ),
        ),
      ),
      home: const BillSplitterPage(),
    );
  }
}

class BillSplitterPage extends StatefulWidget {
  const BillSplitterPage({super.key});

  @override
  State<BillSplitterPage> createState() => _BillSplitterPageState();
}

class _BillSplitterPageState extends State<BillSplitterPage> {
  final _amountController = TextEditingController();
  int _people = 2;
  int _tipPercent = 10;

  double get _amount =>
      double.tryParse(_amountController.text.trim().replaceAll(',', '.')) ?? 0;
  int get _totalCents => (_amount * (1 + _tipPercent / 100) * 100).round();
  int get _baseCents => (_amount * 100).round();
  int get _tipCents => _totalCents - _baseCents;
  int get _shareCents => _totalCents ~/ _people;
  int get _extraCentShares => _totalCents % _people;

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 22,
        title: const Row(
          children: [
            Icon(Icons.receipt_long_rounded, size: 22),
            SizedBox(width: 9),
            Text(
              'cuenta clara',
              style: TextStyle(fontSize: 19, fontWeight: FontWeight.w800),
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'Limpiar cuenta',
            onPressed: () => setState(() {
              _amountController.clear();
              _people = 2;
              _tipPercent = 10;
            }),
            icon: const Icon(Icons.restart_alt_rounded),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        top: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(22, 12, 22, 32),
          children: [
            const Text(
              'La cuenta,\nentre todos.',
              style: TextStyle(
                color: Color(0xFF18231E),
                fontSize: 34,
                height: 1.08,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Sin hacer cuentas en la servilleta.',
              style: TextStyle(color: Color(0xFF737B75), fontSize: 15),
            ),
            const SizedBox(height: 28),
            const _SectionLabel(number: '01', title: 'Total de la cuenta'),
            const SizedBox(height: 11),
            TextField(
              controller: _amountController,
              onChanged: (_) => setState(() {}),
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]')),
              ],
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
              decoration: const InputDecoration(
                prefixText: '\$ ',
                hintText: '0',
                suffixText: 'COP',
              ),
            ),
            const SizedBox(height: 24),
            const _SectionLabel(number: '02', title: '¿Cuántas personas?'),
            const SizedBox(height: 11),
            Row(
              children: [
                _StepperButton(
                  icon: Icons.remove_rounded,
                  label: 'Quitar una persona',
                  onPressed: _people > 1
                      ? () => setState(() => _people--)
                      : null,
                ),
                SizedBox(
                  width: 64,
                  child: Text(
                    '$_people',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 23,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                _StepperButton(
                  icon: Icons.add_rounded,
                  label: 'Agregar una persona',
                  onPressed: () => setState(() => _people++),
                ),
                const SizedBox(width: 12),
                Text(
                  _people == 1 ? 'persona' : 'personas',
                  style: const TextStyle(color: Color(0xFF737B75)),
                ),
              ],
            ),
            const SizedBox(height: 24),
            const _SectionLabel(number: '03', title: 'Agregar propina'),
            const SizedBox(height: 11),
            SegmentedButton<int>(
              showSelectedIcon: false,
              segments: const [
                ButtonSegment(value: 0, label: Text('0%')),
                ButtonSegment(value: 10, label: Text('10%')),
                ButtonSegment(value: 15, label: Text('15%')),
                ButtonSegment(value: 20, label: Text('20%')),
              ],
              selected: {_tipPercent},
              onSelectionChanged: (selection) =>
                  setState(() => _tipPercent = selection.first),
              style: ButtonStyle(
                foregroundColor: WidgetStateProperty.resolveWith(
                  (states) => states.contains(WidgetState.selected)
                      ? Colors.white
                      : const Color(0xFF4C5750),
                ),
                backgroundColor: WidgetStateProperty.resolveWith(
                  (states) => states.contains(WidgetState.selected)
                      ? const Color(0xFF176B52)
                      : Colors.white,
                ),
                side: WidgetStateProperty.all(
                  const BorderSide(color: Color(0xFFE1E5DF)),
                ),
              ),
            ),
            const SizedBox(height: 28),
            _TotalPanel(
              total: _totalCents,
              tip: _tipCents,
              tipPercent: _tipPercent,
              people: _people,
              share: _shareCents,
              extraCentShares: _extraCentShares,
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel({required this.number, required this.title});

  final String number;
  final String title;

  @override
  Widget build(BuildContext context) => Row(
    children: [
      Text(
        number,
        style: const TextStyle(
          color: Color(0xFF176B52),
          fontSize: 12,
          fontWeight: FontWeight.w800,
        ),
      ),
      const SizedBox(width: 9),
      Text(
        title,
        style: const TextStyle(
          color: Color(0xFF26332C),
          fontSize: 15,
          fontWeight: FontWeight.w700,
        ),
      ),
    ],
  );
}

class _StepperButton extends StatelessWidget {
  const _StepperButton({
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  final IconData icon;
  final String label;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) => SizedBox(
    width: 44,
    height: 44,
    child: IconButton(
      tooltip: label,
      onPressed: onPressed,
      style: IconButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF176B52),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: Color(0xFFE1E5DF)),
        ),
      ),
      icon: Icon(icon),
    ),
  );
}

class _TotalPanel extends StatelessWidget {
  const _TotalPanel({
    required this.total,
    required this.tip,
    required this.tipPercent,
    required this.people,
    required this.share,
    required this.extraCentShares,
  });

  final int total;
  final int tip;
  final int tipPercent;
  final int people;
  final int share;
  final int extraCentShares;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      color: const Color(0xFF173F32),
      borderRadius: BorderRadius.circular(16),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'CADA PERSONA PAGA',
          style: TextStyle(
            color: Color(0xFFB9D5C7),
            fontSize: 11,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          _formatMoney(share),
          key: const Key('perPersonAmount'),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 34,
            fontWeight: FontWeight.w800,
          ),
        ),
        if (extraCentShares > 0)
          Text(
            'Las primeras $extraCentShares personas pagan ${_formatMoney(share + 1)} para cuadrar los centavos.',
            style: const TextStyle(color: Color(0xFFB9D5C7), fontSize: 12),
          ),
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 16),
          child: Divider(color: Color(0xFF3D6556), height: 1),
        ),
        _SummaryLine(label: 'Total con propina', value: _formatMoney(total)),
        const SizedBox(height: 9),
        _SummaryLine(label: 'Propina ($tipPercent%)', value: _formatMoney(tip)),
        const SizedBox(height: 9),
        _SummaryLine(label: 'Dividido entre', value: '$people personas'),
      ],
    ),
  );
}

class _SummaryLine extends StatelessWidget {
  const _SummaryLine({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(label, style: const TextStyle(color: Color(0xFFB9D5C7))),
      Text(
        value,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w700,
        ),
      ),
    ],
  );
}

String _formatMoney(int cents) {
  final amount = cents ~/ 100;
  final remainder = (cents % 100).toString().padLeft(2, '0');
  final grouped = amount.toString().replaceAllMapped(
    RegExp(r'\B(?=(\d{3})+(?!\d))'),
    (_) => '.',
  );
  return '\$ $grouped,$remainder';
}
