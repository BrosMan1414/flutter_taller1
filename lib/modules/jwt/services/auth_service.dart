import 'dart:convert';

import 'package:http/http.dart' as http;

/// Servicio responsable de las llamadas HTTP relacionadas con autenticación.
class AuthService {
  final String baseUrl;

  AuthService({this.baseUrl = 'https://parking.visiontic.com.co'});

  /// Realiza login con email y password. Retorna el JSON decodificado en caso de éxito.
  /// Lanza excepción con mensaje amigable en caso de error.
  Future<Map<String, dynamic>> login(String email, String password) async {
    final url = Uri.parse('$baseUrl/api/login');
    try {
      final resp = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );
      // Parse JSON if possible and accept multiple shapes. The API may return:
      // - { success: true, data: { access_token, user } }
      // - { access_token: ..., user: ... }
      // - { token: ..., user: ... }
      Map<String, dynamic>? parsed;
      try {
        final body = jsonDecode(resp.body);
        if (body is Map<String, dynamic>) parsed = body;
      } catch (_) {
        // body not JSON
      }

      if (parsed != null) {
        // If API uses success/data envelope
        if (parsed['success'] == true &&
            parsed['data'] is Map<String, dynamic>) {
          return parsed['data'] as Map<String, dynamic>;
        }

        // If token is at top-level
        if (parsed.containsKey('access_token') || parsed.containsKey('token')) {
          return parsed;
        }

        // If data exists but is not under 'data' key (some APIs return user/token directly)
        if (parsed.containsKey('data')) {
          final d = parsed['data'];
          if (d is Map<String, dynamic>) return d;
        }
      }

      // If we reach here and the status is OK but we couldn't parse a token, bubble a descriptive error
      if (resp.statusCode >= 200 && resp.statusCode < 300) {
        throw Exception(
          'Token no recibido del servidor (respuesta: ${resp.body})',
        );
      }

      // Non-2xx: try to extract server message
      String serverMessage = resp.reasonPhrase ?? resp.body;
      if (parsed != null) {
        serverMessage = parsed['message'] ?? parsed['error'] ?? serverMessage;
      }
      throw Exception('HTTP ${resp.statusCode}: $serverMessage');
    } catch (e) {
      // Propagar excepción (puede ser de red o JSON)
      rethrow;
    }
  }

  /// Registro opcional (depende del backend). Retorna JSON decodificado.
  Future<Map<String, dynamic>> register(
    String name,
    String email,
    String password,
  ) async {
    // The documentation exposes user creation at /api/users
    final url = Uri.parse('$baseUrl/api/users');
    final resp = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'name': name, 'email': email, 'password': password}),
    );

    // Try to accept both possible shapes: a {success: true, data: {...}} response
    // or a 201 Created with a user object in the body.
    try {
      final body = jsonDecode(resp.body);
      if (body is Map<String, dynamic>) {
        // If validation error, provide detailed messages
        if (resp.statusCode == 422) {
          // Common Laravel-style validation error: {message: 'The given data was invalid.', errors: {field: [..]}}
          final errors = <String>[];
          if (body['errors'] is Map<String, dynamic>) {
            (body['errors'] as Map<String, dynamic>).forEach((k, v) {
              if (v is List)
                errors.addAll(v.map((e) => '$k: $e'));
              else
                errors.add('$k: $v');
            });
          }
          final msg = errors.isNotEmpty
              ? errors.join(' | ')
              : (body['message'] ?? resp.body);
          throw Exception('Registro fallido (422): $msg');
        }
        if (body['success'] == true && body['data'] != null) {
          final data = body['data'];
          return data is Map<String, dynamic> ? data : {'data': data};
        }

        // If API returns the created user directly (201)
        if (resp.statusCode == 201) {
          return body;
        }

        final serverMessage = body['message'] ?? body['error'] ?? resp.body;
        throw Exception(
          'Registro fallido (status: ${resp.statusCode}): $serverMessage',
        );
      }
    } catch (_) {
      // If response is not JSON or other error, continue to status check below
    }

    if (resp.statusCode == 201) {
      // Created but not JSON-parsed above; return raw body in map
      return {'raw': resp.body};
    }

    throw Exception('Registro fallido (status: ${resp.statusCode})');
  }

  /// Obtener perfil del usuario autenticado.
  /// Debe pasarse el token JWT (Bearer).
  Future<Map<String, dynamic>> getProfile(String accessToken) async {
    // API documentation uses Spanish path: /api/perfil
    final url = Uri.parse('$baseUrl/api/perfil');
    final resp = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (resp.statusCode >= 200 && resp.statusCode < 300) {
      return jsonDecode(resp.body) as Map<String, dynamic>;
    }

    throw Exception(
      'Profile request failed: HTTP ${resp.statusCode}: ${resp.body}',
    );
  }

  /// Listar usuarios (GET /api/users). Token opcional si el endpoint lo requiere.
  Future<List<dynamic>> getUsers({String? accessToken}) async {
    final url = Uri.parse('$baseUrl/api/users');
    final headers = {'Content-Type': 'application/json'};
    if (accessToken != null) headers['Authorization'] = 'Bearer $accessToken';
    final resp = await http.get(url, headers: headers);
    if (resp.statusCode >= 200 && resp.statusCode < 300) {
      final body = jsonDecode(resp.body);
      if (body is List) return body;
      // If API wraps list inside data: { data: [...] }
      if (body is Map<String, dynamic> && body['data'] is List)
        return body['data'] as List<dynamic>;
      return [body];
    }

    throw Exception('Get users failed: HTTP ${resp.statusCode}: ${resp.body}');
  }

  /// Cierra sesión en el servidor (POST /api/logout). Requiere Authorization Bearer.
  Future<void> logout(String accessToken) async {
    final url = Uri.parse('$baseUrl/api/logout');
    final resp = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (resp.statusCode >= 200 && resp.statusCode < 300) {
      return;
    }

    // Si el servidor responde con error, lanzar excepción con el body para debugging
    String body = resp.body;
    try {
      final parsed = jsonDecode(resp.body);
      if (parsed is Map<String, dynamic>) {
        body = parsed['message'] ?? parsed.toString();
      }
    } catch (_) {}

    throw Exception('Logout failed: HTTP ${resp.statusCode}: $body');
  }
}
