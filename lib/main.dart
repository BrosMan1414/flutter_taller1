import 'package:flutter/material.dart';
import 'package:flutter_taller1/routes/app_router.dart';
import 'package:flutter_taller1/themes/app_theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    //go_router para navegacion
    return MaterialApp.router(
      theme:
          AppTheme.dark, //thema personalizado y permamente en toda la app
      title: 'Flutter - UCEVA', // Usa el tema personalizado.
      routerConfig: appRouter, // Usa el router configurado
    );
  }
}
