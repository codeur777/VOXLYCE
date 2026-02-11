import '../../core/services/api_service.dart';
import '../../core/services/storage_service.dart';
import '../../core/constants/api_constants.dart';
import '../models/auth_response_model.dart';

/// Auth Repository
class AuthRepository {
  final ApiService _apiService = ApiService();
  final StorageService _storageService = StorageService();

  /// Login
  Future<AuthResponseModel> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _apiService.post(
        ApiConstants.login,
        data: {
          'email': email,
          'password': password,
        },
      );

      final authResponse = AuthResponseModel.fromJson(response.data);

      // Save token and user data
      if (authResponse.token != null) {
        await _storageService.saveToken(authResponse.token!);
        await _storageService.saveUserEmail(authResponse.email);
        await _storageService.saveUserRole(authResponse.role);
      }

      return authResponse;
    } catch (e) {
      rethrow;
    }
  }

  /// Register
  Future<AuthResponseModel> register({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    required String role,
    String? classroom,
  }) async {
    try {
      final response = await _apiService.post(
        ApiConstants.register,
        data: {
          'firstName': firstName,
          'lastName': lastName,
          'email': email,
          'password': password,
          'role': role,
          if (classroom != null) 'classroom': classroom,
        },
      );

      final authResponse = AuthResponseModel.fromJson(response.data);

      // Save token and user data
      if (authResponse.token != null) {
        await _storageService.saveToken(authResponse.token!);
        await _storageService.saveUserEmail(authResponse.email);
        await _storageService.saveUserRole(authResponse.role);
      }

      return authResponse;
    } catch (e) {
      rethrow;
    }
  }

  /// Verify 2FA
  Future<AuthResponseModel> verify2FA({
    required String email,
    required String code,
  }) async {
    try {
      final response = await _apiService.post(
        ApiConstants.verify2FA,
        data: {
          'email': email,
          'code': code,
        },
      );

      final authResponse = AuthResponseModel.fromJson(response.data);

      // Save token
      if (authResponse.token != null) {
        await _storageService.saveToken(authResponse.token!);
      }

      return authResponse;
    } catch (e) {
      rethrow;
    }
  }

  /// Logout
  Future<void> logout() async {
    await _storageService.clearAll();
  }

  /// Check if logged in
  Future<bool> isLoggedIn() async {
    return await _storageService.isLoggedIn();
  }

  /// Get user role
  Future<String?> getUserRole() async {
    return await _storageService.getUserRole();
  }
}
