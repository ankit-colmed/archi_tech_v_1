import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/network/api_client.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_local_datasource.dart';
import '../models/user_model.dart';

/// Access token constant for demo purposes
/// In production, this should come from login API response
const String kDemoAccessToken = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6NCwiYXBwX21vZHVsZSI6MSwicGxhdGZvcm0iOjIsImlhdCI6MTc2ODk4NDY4MSwiZXhwIjoxNzc0MjQwNjgxfQ._DAxOIz6ZMwrOu4p6ab2KK-YsareM-Tim1vRFBtSxDM';

/// Implementation of AuthRepository
class AuthRepositoryImpl implements AuthRepository {
  final AuthLocalDataSource localDataSource;
  final ApiClient apiClient;

  AuthRepositoryImpl({
    required this.localDataSource,
    required this.apiClient,
  });

  @override
  Future<Either<Failure, User>> login({
    required String email,
    required String password,
  }) async {
    try {
      // For demo purposes, we'll simulate a login
      // In production, make actual API call here
      // final response = await apiClient.post(
      //   ApiEndpoints.login,
      //   data: {'email': email, 'password': password},
      // );

      // Simulate successful login with demo token
      if (email.isNotEmpty && password.length >= 6) {
        final user = UserModel(
          id: 1,
          email: email,
          name: 'Demo User',
          accessToken: kDemoAccessToken,
        );

        // Save user session
        await saveUserSession(user);

        // Set token in API client
        apiClient.setAccessToken(user.accessToken);

        return Right(user);
      } else {
        return const Left(AuthFailure(message: 'Invalid credentials'));
      }
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      // Clear local session
      await clearUserSession();

      // Clear token from API client
      apiClient.clearAccessToken();

      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, User?>> getCurrentUser() async {
    try {
      final cachedUser = await localDataSource.getCachedUser();
      if (cachedUser != null) {
        // Set token in API client
        apiClient.setAccessToken(cachedUser.accessToken);
        return Right(cachedUser);
      }
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure(message: e.toString()));
    }
  }

  @override
  Future<bool> isLoggedIn() async {
    return await localDataSource.isLoggedIn();
  }

  @override
  Future<void> saveUserSession(User user) async {
    final userModel = UserModel.fromEntity(user);
    await localDataSource.saveUser(userModel);
  }

  @override
  Future<void> clearUserSession() async {
    await localDataSource.clearCachedUser();
  }
}
