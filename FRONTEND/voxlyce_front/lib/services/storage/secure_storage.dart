import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Secure Storage Service for sensitive data
class SecureStorageService {
  static final SecureStorageService _instance = SecureStorageService._internal();
  factory SecureStorageService() => _instance;
  SecureStorageService._internal();

  final FlutterSecureStorage _storage = const FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
    ),
    iOptions: IOSOptions(
      accessibility: KeychainAccessibility.first_unlock,
    ),
  );

  // Storage Keys
  static const String _keyToken = 'jwt_token';
  static const String _keyRefreshToken = 'refresh_token';
  static const String _keyUserId = 'user_id';
  static const String _keyUserEmail = 'user_email';
  static const String _keyUserRole = 'user_role';
  static const String _keyUserFirstName = 'user_first_name';
  static const String _keyUserLastName = 'user_last_name';
  static const String _keyBiometricEnabled = 'biometric_enabled';

  // Token Management
  Future<void> saveToken(String token) async {
    await _storage.write(key: _keyToken, value: token);
  }

  Future<String?> getToken() async {
    return await _storage.read(key: _keyToken);
  }

  Future<void> deleteToken() async {
    await _storage.delete(key: _keyToken);
  }

  // Refresh Token Management
  Future<void> saveRefreshToken(String refreshToken) async {
    await _storage.write(key: _keyRefreshToken, value: refreshToken);
  }

  Future<String?> getRefreshToken() async {
    return await _storage.read(key: _keyRefreshToken);
  }

  Future<void> deleteRefreshToken() async {
    await _storage.delete(key: _keyRefreshToken);
  }

  // User Data Management
  Future<void> saveUserId(String userId) async {
    await _storage.write(key: _keyUserId, value: userId);
  }

  Future<String?> getUserId() async {
    return await _storage.read(key: _keyUserId);
  }

  Future<void> saveUserEmail(String email) async {
    await _storage.write(key: _keyUserEmail, value: email);
  }

  Future<String?> getUserEmail() async {
    return await _storage.read(key: _keyUserEmail);
  }

  Future<void> saveUserRole(String role) async {
    await _storage.write(key: _keyUserRole, value: role);
  }

  Future<String?> getUserRole() async {
    return await _storage.read(key: _keyUserRole);
  }

  Future<void> saveUserFirstName(String firstName) async {
    await _storage.write(key: _keyUserFirstName, value: firstName);
  }

  Future<String?> getUserFirstName() async {
    return await _storage.read(key: _keyUserFirstName);
  }

  Future<void> saveUserLastName(String lastName) async {
    await _storage.write(key: _keyUserLastName, value: lastName);
  }

  Future<String?> getUserLastName() async {
    return await _storage.read(key: _keyUserLastName);
  }

  // Biometric Settings
  Future<void> setBiometricEnabled(bool enabled) async {
    await _storage.write(
      key: _keyBiometricEnabled,
      value: enabled.toString(),
    );
  }

  Future<bool> isBiometricEnabled() async {
    final value = await _storage.read(key: _keyBiometricEnabled);
    return value == 'true';
  }

  // Check if user is logged in
  Future<bool> isLoggedIn() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }

  // Clear all data (logout)
  Future<void> clearAll() async {
    await _storage.deleteAll();
  }

  // Clear only auth data (keep settings)
  Future<void> clearAuthData() async {
    await deleteToken();
    await deleteRefreshToken();
    await _storage.delete(key: _keyUserId);
    await _storage.delete(key: _keyUserEmail);
    await _storage.delete(key: _keyUserRole);
    await _storage.delete(key: _keyUserFirstName);
    await _storage.delete(key: _keyUserLastName);
  }

  // Get all stored keys (for debugging)
  Future<Map<String, String>> getAllData() async {
    return await _storage.readAll();
  }

  // Check if a key exists
  Future<bool> containsKey(String key) async {
    return await _storage.containsKey(key: key);
  }
}
