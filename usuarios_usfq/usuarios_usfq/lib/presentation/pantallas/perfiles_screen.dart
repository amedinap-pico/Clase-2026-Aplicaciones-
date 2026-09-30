import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/perfiles_provider.dart';
import '../providers/sesion_provider.dart';
import 'login_screen.dart';

class PerfilesScreen extends StatefulWidget {
  const PerfilesScreen({super.key});

  @override
  State<PerfilesScreen> createState() => _PerfilesScreenState();
}

class _PerfilesScreenState extends State<PerfilesScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) context.read<PerfilesProvider>().cargar();
    });
  }

  @override
  Widget build(BuildContext context) {
    final estado = context.watch<PerfilesProvider>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfiles'),
        actions: [
          IconButton(
            tooltip: 'Actualizar',
            onPressed: () => context.read<PerfilesProvider>().cargar(),
            icon: const Icon(Icons.refresh),
          ),
          IconButton(
            tooltip: 'Cerrar sesión',
            onPressed: _cerrarSesion,
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: estado.cargando
          ? const Center(child: CircularProgressIndicator())
          : estado.error != null
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Text(
                      estado.error!,
                      style: const TextStyle(color: Colors.red),
                      textAlign: TextAlign.center,
                    ),
                  ),
                )
              : estado.perfiles.isEmpty
                  ? const Center(child: Text('Todavía no hay perfiles.'))
                  : RefreshIndicator(
                      onRefresh: () =>
                          context.read<PerfilesProvider>().cargar(),
                      child: ListView.builder(
                        itemCount: estado.perfiles.length,
                        itemBuilder: (context, index) {
                          final perfil = estado.perfiles[index];
                          return ListTile(
                            title: Text(perfil.nombre),
                            subtitle: Text(
                              perfil.creadoEn.toLocal().toString(),
                            ),
                          );
                        },
                      ),
                    ),
    );
  }

  Future<void> _cerrarSesion() async {
    await context.read<SesionProvider>().salir();
    if (!mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute<void>(builder: (_) => const LoginScreen()),
      (_) => false,
    );
  }
}
