import 'dart:async';

import 'auth_service.dart';

/// FakeAuthService: implementación en memoria para desarrollo y tests.
/// Extiende AuthService para que sea compatible con `AuthProvider`.
class FakeAuthService extends AuthService {
  FakeAuthService() : super();

  @override
  Future<Map<String, dynamic>> login(String email, String password) async {
    await Future.delayed(const Duration(milliseconds: 500));
    if (email.isEmpty || password.isEmpty) {
      throw Exception('HTTP 401: Credenciales inválidas (modo demo)');
    }
    final token = 'fake-token-${DateTime.now().millisecondsSinceEpoch}';
    return {
      'access_token': token,
      'user': {
        'name': email.split('@').first.replaceAll('.', ' ').toUpperCase(),
        'email': email,
      },
    };
  }

  @override
  Future<Map<String, dynamic>> register(
    String name,
    String email,
    String password,
  ) async {
    await Future.delayed(const Duration(milliseconds: 400));
    if (email.isEmpty || password.isEmpty) {
      throw Exception('Registro fallido: datos incompletos (modo demo)');
    }
    return {
      'access_token': 'fake-token-${DateTime.now().millisecondsSinceEpoch}',
      'user': {'name': name, 'email': email},
    };
  }
}
