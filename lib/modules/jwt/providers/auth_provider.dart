import 'package:flutter/material.dart';

import '../services/auth_service.dart';
import '../services/storage_service.dart';

enum AuthStatus { idle, loading, authenticated, error }

class AuthProvider extends ChangeNotifier {
  final AuthService authService;
  final StorageService storage;

  AuthStatus status = AuthStatus.idle;
  String? errorMessage;
  Map<String, dynamic>? user;

  AuthProvider({required this.authService, required this.storage});

  Future<void> login(String email, String password) async {
    status = AuthStatus.loading;
    errorMessage = null;
    notifyListeners();

    try {
      // AuthService devuelve el objeto `data` (según la API: {success:true, data: {...}})
      final data = await authService.login(email, password);

      // Se espera: data['access_token'] y data['user']
      final token = data['access_token'] ?? data['token'];
      final refresh = data['refresh_token'];

      // Datos públicos (nombre/email) suelen venir en data['user']
      final userData = (data['user'] is Map<String, dynamic>)
          ? data['user'] as Map<String, dynamic>
          : data;

      if (token == null) {
        throw Exception('Token no recibido del servidor');
      }

      await storage.saveTokens(
        accessToken: token.toString(),
        refreshToken: refresh?.toString(),
      );
      await storage.saveUser(
        name: userData['name']?.toString(),
        email: userData['email']?.toString(),
      );

      user = userData.cast<String, dynamic>();
      status = AuthStatus.authenticated;
      notifyListeners();
    } catch (e) {
      status = AuthStatus.error;
      errorMessage = e.toString();
      notifyListeners();
    }
  }

  Future<void> logout() async {
    // Attempt to notify server (invalidate token) if present, but always clear local storage
    try {
      final token = await storage.getAccessToken();
      if (token != null && token.isNotEmpty) {
        await authService.logout(token);
      }
    } catch (_) {
      // ignore server logout errors — proceed to clear local state
    }

    await storage.clearAll();
    user = null;
    status = AuthStatus.idle;
    notifyListeners();
  }

  /// Registra un usuario y, si la creación fue exitosa, intenta login automático.
  /// Retorna true si quedó autenticado, false si hubo error.
  Future<bool> registerAndLogin(
    String name,
    String email,
    String password,
  ) async {
    status = AuthStatus.loading;
    errorMessage = null;
    notifyListeners();

    try {
      await authService.register(name, email, password);
      await login(email, password);
      return status == AuthStatus.authenticated;
    } catch (e) {
      status = AuthStatus.error;
      errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  /// Crear una sesión demo local (sin backend). Guarda un token ficticio y datos públicos.
  Future<void> loginDemo(String email, {String? name}) async {
    status = AuthStatus.loading;
    notifyListeners();

    // Token demo
    final demoToken =
        'demo-token-' + DateTime.now().millisecondsSinceEpoch.toString();
    await storage.saveTokens(accessToken: demoToken);
    await storage.saveUser(name: name ?? 'Demo User', email: email);

    user = {'name': name ?? 'Demo User', 'email': email};
    status = AuthStatus.authenticated;
    notifyListeners();
  }

  Future<void> loadFromStorage() async {
    final has = await storage.hasToken();
    if (has) {
      status = AuthStatus.authenticated;
      user = {
        'name': await storage.getName(),
        'email': await storage.getEmail(),
      };
    } else {
      status = AuthStatus.idle;
    }
    notifyListeners();
  }
}
