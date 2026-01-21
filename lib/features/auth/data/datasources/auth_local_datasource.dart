import 'dart:convert';

import 'package:flutter/foundation.dart';

import '../models/user_model.dart';

/// Storage keys
class AuthStorageKeys {
  static const String userKey = 'cached_user';
  static const String tokenKey = 'access_token';
  static const String isLoggedInKey = 'is_logged_in';
}

/// Abstract auth local data source
abstract class AuthLocalDataSource {
  /// Save user to local storage
  Future<void> saveUser(UserModel user);

  /// Get cached user
  Future<UserModel?> getCachedUser();

  /// Clear cached user
  Future<void> clearCachedUser();

  /// Check if user is logged in
  Future<bool> isLoggedIn();

  /// Get access token
  Future<String?> getAccessToken();
}

/// Implementation of auth local data source
/// Using simple in-memory storage for demo (replace with SharedPreferences or secure storage in production)
class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  // Simple in-memory storage (replace with SharedPreferences in production)
  static final Map<String, String> _storage = {};

  @override
  Future<void> saveUser(UserModel user) async {
    try {
      final userJson = jsonEncode(user.toJson());
      _storage[AuthStorageKeys.userKey] = userJson;
      _storage[AuthStorageKeys.tokenKey] = user.accessToken;
      _storage[AuthStorageKeys.isLoggedInKey] = 'true';
    } catch (e) {
      debugPrint('Error saving user: $e');
      rethrow;
    }
  }

  @override
  Future<UserModel?> getCachedUser() async {
    try {
      final userJson = _storage[AuthStorageKeys.userKey];
      if (userJson != null) {
        final Map<String, dynamic> json = jsonDecode(userJson);
        return UserModel.fromJson(json);
      }
      return null;
    } catch (e) {
      debugPrint('Error getting cached user: $e');
      return null;
    }
  }

  @override
  Future<void> clearCachedUser() async {
    try {
      _storage.remove(AuthStorageKeys.userKey);
      _storage.remove(AuthStorageKeys.tokenKey);
      _storage.remove(AuthStorageKeys.isLoggedInKey);
    } catch (e) {
      debugPrint('Error clearing cached user: $e');
      rethrow;
    }
  }

  @override
  Future<bool> isLoggedIn() async {
    final value = _storage[AuthStorageKeys.isLoggedInKey];
    return value == 'true';
  }

  @override
  Future<String?> getAccessToken() async {
    return _storage[AuthStorageKeys.tokenKey];
  }
}
