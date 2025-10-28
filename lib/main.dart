import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_taller1/routes/app_router.dart';
import 'package:flutter_taller1/themes/app_theme.dart';

import 'modules/jwt/providers/auth_provider.dart';
import 'modules/jwt/services/auth_service.dart';
// removed demo/fake auth usage per request
import 'modules/jwt/services/storage_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Usar el servicio real de autenticación contra la API pública
    final authService = AuthService();

    // Register providers at app root
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthProvider>(
          create: (_) {
            final p = AuthProvider(
              authService: authService,
              storage: StorageService(),
            );
            // Load persisted session if any
            p.loadFromStorage();
            return p;
          },
        ),
      ],
      child: MaterialApp.router(
        theme: AppTheme.dark, // tema personalizado y permamente en toda la app
        title: 'Flutter - UCEVA',
        routerConfig: appRouter,
      ),
    );
  }
}
