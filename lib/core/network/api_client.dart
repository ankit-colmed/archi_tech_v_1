import 'package:dio/dio.dart';
import '../constants/api_endpoints.dart';
import '../error/exceptions.dart';

/// API client using Dio
class ApiClient {
  final Dio _dio;
  String? _accessToken = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJob3NwaXRhbF9pZCI6NCwidXNlcl9pZCI6IjI3IiwicGxhdGZvcm0iOjIsInVzZXJfdHlwZSI6MSwiYXBwX21vZHVsZSI6MSwiaWF0IjoxNzY4OTg0ODIxLCJleHAiOjE3NzQyNDA4MjF9.SJQr398hEsIEGaRjgxiX7NiF_44YOwXygQpTNadnrwQ";

  ApiClient({Dio? dio}) : _dio = dio ?? Dio() {
    _dio.options = BaseOptions(
      baseUrl: ApiEndpoints.apiBaseUrl,
      connectTimeout: const Duration(milliseconds: ApiEndpoints.connectTimeout),
      receiveTimeout: const Duration(milliseconds: ApiEndpoints.receiveTimeout),
      sendTimeout: const Duration(milliseconds: ApiEndpoints.sendTimeout),
      headers: {
        'Content-Type': ApiEndpoints.contentType,
        'Accept': ApiEndpoints.accept,
      },
    );

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          // Add access token to requests
          if (_accessToken != null) {
            options.headers[ApiEndpoints.accessTokenHeader] = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJob3NwaXRhbF9pZCI6NCwidXNlcl9pZCI6IjI3IiwicGxhdGZvcm0iOjIsInVzZXJfdHlwZSI6MSwiYXBwX21vZHVsZSI6MSwiaWF0IjoxNzY4OTg0ODIxLCJleHAiOjE3NzQyNDA4MjF9.SJQr398hEsIEGaRjgxiX7NiF_44YOwXygQpTNadnrwQ";//_accessToken;
          }
          return handler.next(options);
        },
        onResponse: (response, handler) {
          return handler.next(response);
        },
        onError: (error, handler) {
          return handler.next(error);
        },
      ),
    );

    // Add logging interceptor for debug builds
    _dio.interceptors.add(
      LogInterceptor(
        requestBody: true,
        responseBody: true,
        error: true,
      ),
    );
  }

  /// Set access token for authenticated requests
  void setAccessToken(String token) {
    _accessToken = token;
  }

  /// Clear access token
  void clearAccessToken() {
    _accessToken = null;
  }

  /// GET request
  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final response = await _dio.get<T>(
        path,
        queryParameters: queryParameters,
        options: options,
      );
      return response;
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  /// POST request
  Future<Response<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final response = await _dio.post<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
      return response;
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  /// PUT request
  Future<Response<T>> put<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final response = await _dio.put<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
      return response;
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  /// DELETE request
  Future<Response<T>> delete<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final response = await _dio.delete<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
      return response;
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  /// Handle Dio errors and convert to app exceptions
  AppException _handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const NetworkException(message: 'Connection timeout');

      case DioExceptionType.connectionError:
        return const NetworkException();

      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        final data = error.response?.data;
        String message = 'Server error';

        if (data is Map<String, dynamic>) {
          message = data['message'] ?? message;
        }

        if (statusCode == 401 || statusCode == 403) {
          return AuthException(message: message, statusCode: statusCode);
        }

        return ServerException(message: message, statusCode: statusCode);

      case DioExceptionType.cancel:
        return const ServerException(message: 'Request cancelled');

      case DioExceptionType.unknown:
      case DioExceptionType.badCertificate:
      default:
        return ServerException(
          message: error.message ?? 'Unknown error occurred',
        );
    }
  }
}
