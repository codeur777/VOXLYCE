import 'package:dio/dio.dart';
import '../constants/api_constants.dart';
import '../../services/storage/secure_storage.dart';
import '../../services/api/dio_client.dart';

/// API Service for HTTP requests
class ApiService {
  late final DioClient _dioClient;
  final SecureStorageService _secureStorage = SecureStorageService();

  ApiService() {
    _dioClient = DioClient();
    _dioClient.init(enableLogging: true);
  }

  /// GET request
  Future<Response> get(String path, {Map<String, dynamic>? queryParameters}) async {
    try {
      return await _dioClient.get(path, queryParameters: queryParameters);
    } catch (e) {
      rethrow;
    }
  }

  /// POST request
  Future<Response> post(String path, {dynamic data}) async {
    try {
      return await _dioClient.post(path, data: data);
    } catch (e) {
      rethrow;
    }
  }

  /// PUT request
  Future<Response> put(String path, {dynamic data}) async {
    try {
      return await _dioClient.put(path, data: data);
    } catch (e) {
      rethrow;
    }
  }

  /// DELETE request
  Future<Response> delete(String path) async {
    try {
      return await _dioClient.delete(path);
    } catch (e) {
      rethrow;
    }
  }

  /// PATCH request
  Future<Response> patch(String path, {dynamic data}) async {
    try {
      return await _dioClient.patch(path, data: data);
    } catch (e) {
      rethrow;
    }
  }
}
