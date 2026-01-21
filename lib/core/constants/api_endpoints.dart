/// Centralized API endpoints and configuration
class ApiEndpoints {
  ApiEndpoints._();

  // Base URL
  static const String baseUrl = 'https://api.hepabuddy.com';
  static const String apiVersion = '/v4';
  
  // Full Base URL
  static const String apiBaseUrl = '$baseUrl$apiVersion';

  // Auth Endpoints
  static const String login = '/auth/login';
  static const String logout = '/auth/logout';
  static const String refreshToken = '/auth/refresh';

  // Patient Endpoints
  static const String patients = '/hepabuddy/patient/getall';
  static const String patientDetails = '/hepabuddy/patient'; // + /{id}

  // Headers
  static const String contentType = 'application/json';
  static const String accept = 'application/json';
  static const String accessTokenHeader = 'access-token';

  // Timeouts (in milliseconds)
  static const int connectTimeout = 30000;
  static const int receiveTimeout = 30000;
  static const int sendTimeout = 30000;
}

/// API Response Status
class ApiStatus {
  ApiStatus._();

  static const String success = 'success';
  static const String error = 'error';
  static const String failed = 'failed';
}
