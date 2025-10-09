import 'package:flutter/material.dart';
import '../../widgets/drawer.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard Principal')),
      drawer: const AppDrawer(),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: Center(
          child: Text(
            'Bienvenido al Dashboard Principal',
            style: TextStyle(fontSize: 18),
          ),
        ),
      ),
    );
  }
}
