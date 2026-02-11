import 'package:dio/dio.dart';
import '../storage/secure_storage.dart';

/// JWT Interceptor for adding authentication token to requests
class JwtInterceptor extends Interceptor {
  final SecureStorageService _secureStorage = SecureStorageService();

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // Get token from secure storage
    final token = await _secureStorage.getToken();

    // Add token to headers if available
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    // Add default headers
    options.headers['Content-Type'] = 'application/json';
    options.headers['Accept'] = 'application/json';

    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    // Log successful responses in debug mode
    print('✅ Response [${response.statusCode}]: ${response.requestOptions.path}');
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // Log errors
    print('❌ Error [${err.response?.statusCode}]: ${err.requestOptions.path}');
    print('   Message: ${err.message}');

    // Handle specific error codes
    if (err.response?.statusCode == 401) {
      // Unauthorized - clear token and redirect to login
      _secureStorage.deleteToken();
      print('🔒 Token expired or invalid - cleared from storage');
    }

    super.onError(err, handler);
  }
}

/// Logging Interceptor for debugging
class LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    print('🌐 REQUEST[${options.method}] => PATH: ${options.path}');
    print('   Headers: ${options.headers}');
    if (options.data != null) {
      print('   Data: ${options.data}');
    }
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    print('✅ RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}');
    print('   Data: ${response.data}');
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    print('❌ ERROR[${err.response?.statusCode}] => PATH: ${err.requestOptions.path}');
    print('   Message: ${err.message}');
    print('   Response: ${err.response?.data}');
    super.onError(err, handler);
  }
}

/// Retry Interceptor for handling network failures
class RetryInterceptor extends Interceptor {
  final int maxRetries;
  final Duration retryDelay;

  RetryInterceptor({
    this.maxRetries = 3,
    this.retryDelay = const Duration(seconds: 1),
  });

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (_shouldRetry(err) && err.requestOptions.extra['retryCount'] == null) {
      err.requestOptions.extra['retryCount'] = 0;
    }

    final retryCount = err.requestOptions.extra['retryCount'] as int? ?? 0;

    if (_shouldRetry(err) && retryCount < maxRetries) {
      err.requestOptions.extra['retryCount'] = retryCount + 1;

      print('🔄 Retrying request (${retryCount + 1}/$maxRetries)...');

      // Wait before retrying
      await Future.delayed(retryDelay);

      try {
        // Retry the request
        final response = await Dio().fetch(err.requestOptions);
        return handler.resolve(response);
      } catch (e) {
        return super.onError(err, handler);
      }
    }

    super.onError(err, handler);
  }

  bool _shouldRetry(DioException err) {
    return err.type == DioExceptionType.connectionTimeout ||
        err.type == DioExceptionType.sendTimeout ||
        err.type == DioExceptionType.receiveTimeout ||
        err.type == DioExceptionType.connectionError;
  }
}
