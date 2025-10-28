import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../widgets/drawer.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard Principal')),
      drawer: const AppDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Bienvenido al Dashboard Principal',
                style: TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () {
                  // Navegar a la pantalla de login (JWT)
                  context.go('/login');
                },
                icon: const Icon(Icons.login),
                label: const Text('Iniciar sesión (JWT)'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
