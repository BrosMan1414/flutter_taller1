import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    print('AppDrawer build ejecutado - scheme.primary=${scheme.primary}');
    return Drawer(
      child: SafeArea(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: scheme.primary),
              child: Align(
                alignment: Alignment.bottomLeft,
                child: Text(
                  'Menú',
                  style: TextStyle(
                    color: scheme.onPrimary,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.home, color: scheme.onSurface),
              title: Text('Inicio', style: TextStyle(color: scheme.onSurface)),
              onTap: () {
                context.go('/');
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.timelapse, color: scheme.onSurface),
              title: Text(
                'Asincronía',
                style: TextStyle(color: scheme.onSurface),
              ),
              onTap: () {
                context.go('/asincronia');
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.timer, color: scheme.onSurface),
              title: Text('Timer', style: TextStyle(color: scheme.onSurface)),
              onTap: () {
                context.go('/timer');
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(
                Icons.add_circle_outline_sharp,
                color: scheme.onSurface,
              ),
              title: Text(
                'Isolates',
                style: TextStyle(color: scheme.onSurface),
              ),
              onTap: () {
                context.go('/isolate');
                Navigator.pop(context);
              },
            ),
            const Divider(),
            ListTile(
              leading: Icon(Icons.sailing, color: scheme.onSurface),
              title: Text(
                'One Piece - Listado',
                style: TextStyle(color: scheme.onSurface),
              ),
              onTap: () {
                context.go('/onepiece');
                Navigator.pop(context);
              },
            ),
            const Divider(),
            ListTile(
              leading: Icon(Icons.login, color: scheme.onSurface),
              title: Text(
                'Login (JWT)',
                style: TextStyle(color: scheme.onSurface),
              ),
              onTap: () {
                context.go('/login');
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.verified_user, color: scheme.onSurface),
              title: Text(
                'Evidencia (Sesión)',
                style: TextStyle(color: scheme.onSurface),
              ),
              onTap: () {
                context.go('/evidence');
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.school, color: scheme.onSurface),
              title: Text(
                'Universidades',
                style: TextStyle(color: scheme.onSurface),
              ),
              onTap: () {
                context.go('/universidades');
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
