import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Servicio para persistencia local: tokens en secure storage y datos públicos en shared_preferences.
class StorageService {
  final FlutterSecureStorage _secure = const FlutterSecureStorage();

  // Keys
  static const _kAccessToken = 'access_token';
  static const _kRefreshToken = 'refresh_token';
  static const _kName = 'user_name';
  static const _kEmail = 'user_email';

  // Secure storage (tokens)
  Future<void> saveTokens({
    required String accessToken,
    String? refreshToken,
  }) async {
    await _secure.write(key: _kAccessToken, value: accessToken);
    if (refreshToken != null) {
      await _secure.write(key: _kRefreshToken, value: refreshToken);
    }
  }

  Future<String?> getAccessToken() async =>
      await _secure.read(key: _kAccessToken);
  Future<String?> getRefreshToken() async =>
      await _secure.read(key: _kRefreshToken);
  Future<void> deleteTokens() async {
    await _secure.delete(key: _kAccessToken);
    await _secure.delete(key: _kRefreshToken);
  }

  Future<bool> hasToken() async {
    final t = await getAccessToken();
    return t != null && t.isNotEmpty;
  }

  // Shared preferences (user data non-sensitive)
  Future<void> saveUser({String? name, String? email}) async {
    final sp = await SharedPreferences.getInstance();
    if (name != null) await sp.setString(_kName, name);
    if (email != null) await sp.setString(_kEmail, email);
  }

  Future<String?> getName() async {
    final sp = await SharedPreferences.getInstance();
    return sp.getString(_kName);
  }

  Future<String?> getEmail() async {
    final sp = await SharedPreferences.getInstance();
    return sp.getString(_kEmail);
  }

  Future<void> clearAll() async {
    await deleteTokens();
    final sp = await SharedPreferences.getInstance();
    await sp.remove(_kName);
    await sp.remove(_kEmail);
  }
}
