import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/sesion_provider.dart';
import 'perfiles_screen.dart';
import 'registro_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _correo = TextEditingController();
  final _clave = TextEditingController();
  bool _navegando = false;

  @override
  void dispose() {
    _correo.dispose();
    _clave.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final sesion = context.watch<SesionProvider>();
    if (sesion.idUsuario != null && !_navegando) {
      _navegando = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute<void>(builder: (_) => const PerfilesScreen()),
        );
      });
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Iniciar sesión')),
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
                onSubmitted: (_) => _ingresar(),
              ),
              const SizedBox(height: 16),
              if (sesion.error != null)
                Text(sesion.error!, style: const TextStyle(color: Colors.red)),
              if (sesion.cargando)
                const Center(child: CircularProgressIndicator())
              else
                FilledButton(
                  onPressed: _ingresar,
                  child: const Text('Ingresar'),
                ),
              TextButton(
                onPressed: sesion.cargando
                    ? null
                    : () => Navigator.push(
                          context,
                          MaterialPageRoute<void>(
                            builder: (_) => const RegistroScreen(),
                          ),
                        ),
                child: const Text('Crear una cuenta'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _ingresar() {
    context.read<SesionProvider>().ingresar(_correo.text.trim(), _clave.text);
  }
}
