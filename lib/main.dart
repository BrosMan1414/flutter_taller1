import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'screens/home_screen.dart';
import 'screens/details_screen.dart';
import 'screens/tabs_screen.dart';

void main() {
  runApp(const MyApp());
}

// Router configuration
final GoRouter _router = GoRouter(
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return const HomeScreen();
      },
    ),
    GoRoute(
      path: '/details/:itemId',
      builder: (BuildContext context, GoRouterState state) {
        final String itemId = state.pathParameters['itemId']!;
        final String? title = state.uri.queryParameters['title'];
        final String? description = state.uri.queryParameters['description'];
        return DetailsScreen(
          itemId: itemId,
          title: title ?? 'Sin título',
          description: description ?? 'Sin descripción',
        );
      },
    ),
    GoRoute(
      path: '/tabs',
      builder: (BuildContext context, GoRouterState state) {
        return const TabsScreen();
      },
    ),
  ],
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Taller 1 - Navegación y Ciclo de Vida',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      routerConfig: _router,
    );
  }
}
