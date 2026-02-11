import 'package:shared_preferences/shared_preferences.dart';
import '../../services/storage/secure_storage.dart';

/// Storage Service for local data persistence
class StorageService {
  static final StorageService _instance = StorageService._internal();
  factory StorageService() => _instance;
  StorageService._internal();

  final SecureStorageService _secureStorage = SecureStorageService();
  SharedPreferences? _prefs;

  // Initialize SharedPreferences
  Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  // Token Management (Secure) - Delegate to SecureStorageService
  Future<void> saveToken(String token) async {
    await _secureStorage.saveToken(token);
  }

  Future<String?> getToken() async {
    return await _secureStorage.getToken();
  }

  Future<void> deleteToken() async {
    await _secureStorage.deleteToken();
  }

  // User Data (Secure) - Delegate to SecureStorageService
  Future<void> saveUserEmail(String email) async {
    await _secureStorage.saveUserEmail(email);
  }

  Future<String?> getUserEmail() async {
    return await _secureStorage.getUserEmail();
  }

  Future<void> saveUserRole(String role) async {
    await _secureStorage.saveUserRole(role);
  }

  Future<String?> getUserRole() async {
    return await _secureStorage.getUserRole();
  }

  // Theme Preference
  Future<void> saveThemeMode(bool isDark) async {
    await _prefs?.setBool('is_dark_mode', isDark);
  }

  bool getThemeMode() {
    return _prefs?.getBool('is_dark_mode') ?? false;
  }

  // Onboarding Status
  Future<void> setOnboardingComplete() async {
    await _prefs?.setBool('onboarding_complete', true);
  }

  bool isOnboardingComplete() {
    return _prefs?.getBool('onboarding_complete') ?? false;
  }

  // Language Preference
  Future<void> saveLanguage(String languageCode) async {
    await _prefs?.setString('language', languageCode);
  }

  String getLanguage() {
    return _prefs?.getString('language') ?? 'fr';
  }

  // Notification Settings
  Future<void> setNotificationsEnabled(bool enabled) async {
    await _prefs?.setBool('notifications_enabled', enabled);
  }

  bool areNotificationsEnabled() {
    return _prefs?.getBool('notifications_enabled') ?? true;
  }

  // Clear all data (Logout)
  Future<void> clearAll() async {
    await _secureStorage.clearAll();
    await _prefs?.clear();
  }

  // Check if user is logged in
  Future<bool> isLoggedIn() async {
    return await _secureStorage.isLoggedIn();
  }
}
