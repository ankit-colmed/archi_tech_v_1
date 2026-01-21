/// Base exception class
abstract class AppException implements Exception {
  final String message;
  final int? statusCode;

  const AppException({
    required this.message,
    this.statusCode,
  });

  @override
  String toString() => message;
}

/// Server exception (API errors)
class ServerException extends AppException {
  const ServerException({
    required super.message,
    super.statusCode,
  });
}

/// Cache exception (Local database errors)
class CacheException extends AppException {
  const CacheException({
    required super.message,
  });
}

/// Network exception (No internet)
class NetworkException extends AppException {
  const NetworkException({
    super.message = 'No internet connection',
  });
}

/// Authentication exception
class AuthException extends AppException {
  const AuthException({
    super.message = 'Authentication failed',
    super.statusCode,
  });
}

/// Validation exception
class ValidationException extends AppException {
  final Map<String, String>? fieldErrors;

  const ValidationException({
    required super.message,
    this.fieldErrors,
  });
}
