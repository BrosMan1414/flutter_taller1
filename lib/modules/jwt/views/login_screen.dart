import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

import '../../../widgets/drawer.dart';
import '../providers/auth_provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailCtl = TextEditingController();
  final _passCtl = TextEditingController();

  @override
  void dispose() {
    _emailCtl.dispose();
    _passCtl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (auth.status == AuthStatus.authenticated) {
        context.go('/evidence');
      }
    });

    return Scaffold(
      appBar: AppBar(title: const Text('Login (JWT)')),
      drawer: const AppDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _emailCtl,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _passCtl,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Password'),
            ),
            const SizedBox(height: 20),
            if (auth.status == AuthStatus.loading)
              const CircularProgressIndicator(),
            if (auth.status == AuthStatus.error) ...[
              Text(
                auth.errorMessage ?? 'Error',
                style: const TextStyle(color: Colors.red),
              ),
              const SizedBox(height: 8),
            ],
            ElevatedButton(
              onPressed: auth.status == AuthStatus.loading
                  ? null
                  : () async {
                      FocusScope.of(context).unfocus();
                      await auth.login(
                        _emailCtl.text.trim(),
                        _passCtl.text.trim(),
                      );
                    },
              child: const Text('Login'),
            ),
            const SizedBox(height: 8),
            // Registrar cuenta — abrimos un diálogo con manejo inline de errores 422
            TextButton(
              onPressed: auth.status == AuthStatus.loading
                  ? null
                  : () async {
                      final nameCtl = TextEditingController();
                      final emailCtl = TextEditingController();
                      final passCtl = TextEditingController();

                      final result = await showDialog<bool?>(
                        context: context,
                        builder: (ctx) {
                          final fieldErrors = <String, String>{};
                          return StatefulBuilder(
                            builder: (ctx2, setState) => AlertDialog(
                              title: const Text('Registrar usuario'),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  TextField(
                                    controller: nameCtl,
                                    decoration: InputDecoration(
                                      labelText: 'Name',
                                      errorText: fieldErrors['name'],
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  TextField(
                                    controller: emailCtl,
                                    decoration: InputDecoration(
                                      labelText: 'Email',
                                      errorText: fieldErrors['email'],
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  TextField(
                                    controller: passCtl,
                                    obscureText: true,
                                    decoration: InputDecoration(
                                      labelText: 'Password',
                                      errorText: fieldErrors['password'],
                                    ),
                                  ),
                                  if (fieldErrors['__general'] != null) ...[
                                    const SizedBox(height: 8),
                                    Text(
                                      fieldErrors['__general']!,
                                      style: const TextStyle(color: Colors.red),
                                    ),
                                  ],
                                ],
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () =>
                                      Navigator.of(ctx2).pop(false),
                                  child: const Text('Cancelar'),
                                ),
                                ElevatedButton(
                                  onPressed: () async {
                                    // Intentar registrar y mostrar errores inline si vienen (422)
                                    setState(() => fieldErrors.clear());
                                    try {
                                      await auth.authService.register(
                                        nameCtl.text.trim(),
                                        emailCtl.text.trim(),
                                        passCtl.text.trim(),
                                      );
                                      Navigator.of(ctx2).pop(true);
                                    } catch (e) {
                                      final msg = e.toString();
                                      if (msg.contains('(422):')) {
                                        final idx = msg.indexOf('(422):');
                                        final details = msg
                                            .substring(idx + 7)
                                            .trim();
                                        final items = details.split(' | ');
                                        final parsed = <String, String>{};
                                        for (var it in items) {
                                          final kv = it.split(':');
                                          if (kv.length >= 2) {
                                            final key = kv[0].trim();
                                            final value = kv
                                                .sublist(1)
                                                .join(':')
                                                .trim();
                                            parsed[key] = value;
                                          } else {
                                            parsed['__general'] = it.trim();
                                          }
                                        }
                                        setState(
                                          () => fieldErrors.addAll(parsed),
                                        );
                                      } else {
                                        setState(
                                          () => fieldErrors['__general'] = msg,
                                        );
                                      }
                                    }
                                  },
                                  child: const Text('Registrar'),
                                ),
                              ],
                            ),
                          );
                        },
                      );

                      if (result == true) {
                        if (!mounted) return;
                        try {
                          await auth.login(
                            emailCtl.text.trim(),
                            passCtl.text.trim(),
                          );
                        } catch (_) {
                          if (!mounted) return;
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                auth.errorMessage ?? 'Login automático fallido',
                              ),
                            ),
                          );
                        }
                      }
                    },
              child: const Text('Registrar cuenta'),
            ),
          ],
        ),
      ),
    );
  }
}
