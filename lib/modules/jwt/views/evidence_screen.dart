import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

import '../../../widgets/drawer.dart';
import '../providers/auth_provider.dart';
import '../services/storage_service.dart';

class EvidenceScreen extends StatefulWidget {
  const EvidenceScreen({super.key});

  @override
  State<EvidenceScreen> createState() => _EvidenceScreenState();
}

class _EvidenceScreenState extends State<EvidenceScreen> {
  String? _name;
  String? _email;
  bool _hasToken = false;

  final StorageService _storage = StorageService();

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final name = await _storage.getName();
    final email = await _storage.getEmail();
    final has = await _storage.hasToken();
    if (!mounted) return;
    setState(() {
      _name = name;
      _email = email;
      _hasToken = has;
    });
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(title: const Text('Evidencia - Sesión')),
      drawer: const AppDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Nombre: ${_name ?? 'No disponible'}"),
            const SizedBox(height: 8),
            Text("Correo: ${_email ?? 'No disponible'}"),
            const SizedBox(height: 8),
            Row(
              children: [
                const Text('Token: '),
                Icon(
                  _hasToken ? Icons.check_circle : Icons.error,
                  color: _hasToken ? Colors.green : Colors.red,
                ),
                const SizedBox(width: 8),
                Text(_hasToken ? 'token presente' : 'sin token'),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                await auth.logout();
                if (!mounted) return;
                // Navigate back to home using go_router
                context.go('/');
              },
              child: const Text('Cerrar sesión'),
            ),
          ],
        ),
      ),
    );
  }
}
