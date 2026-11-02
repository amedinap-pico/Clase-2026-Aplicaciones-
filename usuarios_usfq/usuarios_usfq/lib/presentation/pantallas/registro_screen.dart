import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/sesion_provider.dart';
import 'perfiles_screen.dart';

class RegistroScreen extends StatefulWidget {
  const RegistroScreen({super.key});

  @override
  State<RegistroScreen> createState() => _RegistroScreenState();
}

class _RegistroScreenState extends State<RegistroScreen> {
  final _correo = TextEditingController();
  final _clave = TextEditingController();
  final _nombre = TextEditingController();
  bool _navegando = false;

  @override
  void dispose() {
    _correo.dispose();
    _clave.dispose();
    _nombre.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final sesion = context.watch<SesionProvider>();
    if (sesion.idUsuario != null && !_navegando) {
      _navegando = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute<void>(builder: (_) => const PerfilesScreen()),
          (_) => false,
        );
      });
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Crear cuenta')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 440),
          child: ListView(
            padding: const EdgeInsets.all(24),
            shrinkWrap: true,
            children: [
              TextField(
                controller: _correo,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(labelText: 'Correo'),
              ),
              TextField(
                controller: _clave,
                obscureText: true,
                decoration: const InputDecoration(labelText: 'Clave'),
              ),
              TextField(
                controller: _nombre,
                textCapitalization: TextCapitalization.words,
                decoration: const InputDecoration(labelText: 'Nombre'),
                onSubmitted: (_) => _registrar(),
              ),
              const SizedBox(height: 16),
              if (sesion.error != null)
                Text(sesion.error!, style: const TextStyle(color: Colors.red)),
              if (sesion.cargando)
                const Center(child: CircularProgressIndicator())
              else
                FilledButton(
                  onPressed: _registrar,
                  child: const Text('Registrar'),
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _registrar() {
    context.read<SesionProvider>().registrar(
          _correo.text.trim(),
          _clave.text,
          _nombre.text.trim(),
        );
  }
}
