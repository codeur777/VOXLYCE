import 'package:dio/dio.dart';
import '../../core/constants/api_constants.dart';
import 'api_interceptors.dart';

/// Dio Client Configuration
class DioClient {
  static final DioClient _instance = DioClient._internal();
  factory DioClient() => _instance;
  DioClient._internal();

  late final Dio _dio;

  Dio get dio => _dio;

  /// Initialize Dio with configuration and interceptors
  void init({bool enableLogging = true}) {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: ApiConstants.connectTimeout,
        receiveTimeout: ApiConstants.receiveTimeout,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    // Add interceptors
    _dio.interceptors.addAll([
      JwtInterceptor(), // Add JWT token to requests
      if (enableLogging) LoggingInterceptor(), // Log requests/responses
      RetryInterceptor(), // Retry failed requests
    ]);
  }

  /// GET request
  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.get(
        path,
        queryParameters: queryParameters,
        options: options,
      );
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// POST request
  Future<Response> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// PUT request
  Future<Response> put(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.put(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// DELETE request
  Future<Response> delete(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.delete(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// PATCH request
  Future<Response> patch(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.patch(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Handle Dio errors
  Exception _handleError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return Exception('Timeout de connexion. Vérifiez votre connexion internet.');

      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        final message = error.response?.data['message'] ?? 
                       error.response?.data['error'] ?? 
                       'Erreur serveur';
        
        switch (statusCode) {
          case 400:
            return Exception('Requête invalide: $message');
          case 401:
            return Exception('Non autorisé. Veuillez vous reconnecter.');
          case 403:
            return Exception('Accès interdit: $message');
          case 404:
            return Exception('Ressource non trouvée: $message');
          case 500:
            return Exception('Erreur serveur interne: $message');
          default:
            return Exception('Erreur $statusCode: $message');
        }

      case DioExceptionType.cancel:
        return Exception('Requête annulée');

      case DioExceptionType.connectionError:
        return Exception('Erreur de connexion. Vérifiez votre connexion internet.');

      case DioExceptionType.badCertificate:
        return Exception('Certificat SSL invalide');

      case DioExceptionType.unknown:
      default:
        return Exception('Erreur inconnue: ${error.message}');
    }
  }

  /// Clear all interceptors
  void clearInterceptors() {
    _dio.interceptors.clear();
  }

  /// Add custom interceptor
  void addInterceptor(Interceptor interceptor) {
    _dio.interceptors.add(interceptor);
  }
}
